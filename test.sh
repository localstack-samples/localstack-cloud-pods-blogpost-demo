#!/bin/bash
# Upload a valid picture and a file in the wrong format to the shipment
# picture bucket and check the validator Lambda:
# - watermarks the picture in place and tags it with exclude-lambda=true
# - stores a placeholder image next to the invalid file
# - publishes both keys to SNS, which forwards them to the SQS queue
set -euo pipefail

MAX_ATTEMPTS=${MAX_ATTEMPTS:-45}
PREFIX="ci-$(date +%s)"
PICTURE=sample-pictures/cat.jpg
INVALID=sample-pictures/wrong-format-file.txt

BUCKET=$(lstk aws s3api list-buckets \
  --query "Buckets[?starts_with(Name, 'shipment-picture-bucket-')].Name | [0]" --output text)
QUEUE_URL=$(lstk aws sqs get-queue-url --queue-name update_shipment_picture_queue --query QueueUrl --output text)
echo "Bucket: $BUCKET"

lstk aws s3 cp "$PICTURE" "s3://$BUCKET/$PREFIX/cat.jpg" --content-type image/jpeg > /dev/null
lstk aws s3 cp "$INVALID" "s3://$BUCKET/$PREFIX/wrong-format-file.txt" --content-type text/plain > /dev/null
echo "Uploaded $PREFIX/cat.jpg and $PREFIX/wrong-format-file.txt"

ORIGINAL_SIZE=$(wc -c < "$PICTURE" | tr -d ' ')

processed() {
  lstk aws s3api head-object --bucket "$BUCKET" --key "$1" \
    --query 'Metadata."exclude-lambda"' --output text 2>/dev/null || true
}

placeholder=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  picture_done=$(processed "$PREFIX/cat.jpg")
  placeholder=$(lstk aws s3api list-objects-v2 --bucket "$BUCKET" --prefix "$PREFIX/" \
    --query "Contents[?ends_with(Key, '-placeholder.jpg')].Key | [0]" --output text)
  if [ "$picture_done" = "true" ] && [ "$placeholder" != "None" ]; then
    break
  fi
  echo "Attempt $attempt/$MAX_ATTEMPTS: waiting for the validator"
  sleep 2
done

if [ "$(processed "$PREFIX/cat.jpg")" != "true" ]; then
  echo "Test failed: $PREFIX/cat.jpg was not processed"
  exit 1
fi
size=$(lstk aws s3api head-object --bucket "$BUCKET" --key "$PREFIX/cat.jpg" --query ContentLength --output text)
if [ "$size" = "$ORIGINAL_SIZE" ]; then
  echo "Test failed: $PREFIX/cat.jpg is unchanged, the watermark was not applied"
  exit 1
fi
echo "PASS: picture was watermarked ($ORIGINAL_SIZE -> $size bytes)"

if [ "$placeholder" = "None" ] || [ "$(processed "$placeholder")" != "true" ]; then
  echo "Test failed: no placeholder was stored for the invalid file"
  exit 1
fi
echo "PASS: invalid file was replaced by $placeholder"

# Collect the keys published to the topic for this run
published=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  published+=$(lstk aws sqs receive-message --queue-url "$QUEUE_URL" --max-number-of-messages 10 \
    --wait-time-seconds 1 --query 'Messages[].Body' --output json \
    | jq -r '.[]? | fromjson | .Message' | grep "^$PREFIX/" || true)
  published+=$'\n'
  if grep -qx "$PREFIX/cat.jpg" <<< "$published" && grep -qx "$placeholder" <<< "$published"; then
    break
  fi
  sleep 1
done
if ! grep -qx "$PREFIX/cat.jpg" <<< "$published" || ! grep -qx "$placeholder" <<< "$published"; then
  echo "Test failed: expected both keys on the queue, got: $(sort -u <<< "$published" | tr '\n' ' ')"
  exit 1
fi
echo "PASS: both keys were published through SNS to SQS"

echo "Test passed: the validator processed both uploads"
