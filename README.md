

# Cloud Pods Demos


| Environment      | <img src="https://img.shields.io/badge/LocalStack-deploys-4D29B4.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAKgAAACoABZrFArwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAALbSURBVHic7ZpNaxNRFIafczNTGIq0G2M7pXWRlRv3Lusf8AMFEQT3guDWhX9BcC/uFAr1B4igLgSF4EYDtsuQ3M5GYrTaj3Tmui2SpMnM3PlK3m1uzjnPw8xw50MoaNrttl+r1e4CNRv1jTG/+v3+c8dG8TSilHoAPLZVX0RYWlraUbYaJI2IuLZ7KKUWCisgq8wF5D1A3rF+EQyCYPHo6Ghh3BrP8wb1en3f9izDYlVAp9O5EkXRB8dxxl7QBoNBpLW+7fv+a5vzDIvVU0BELhpjJrmaK2NMw+YsIxunUaTZbLrdbveZ1vpmGvWyTOJToNlsuqurq1vAdWPMeSDzwzhJEh0Bp+FTmifzxBZQBXiIKaAq8BBDQJXgYUoBVYOHKQRUER4mFFBVeJhAQJXh4QwBVYeHMQJmAR5GCJgVeBgiYJbg4T8BswYPp+4GW63WwvLy8hZwLcd5TudvBj3+OFBIeA4PD596nvc1iiIrD21qtdr+ysrKR8cY42itCwUP0Gg0+sC27T5qb2/vMunB/0ipTmZxfN//orW+BCwmrGV6vd63BP9P2j9WxGbxbrd7B3g14fLfwFsROUlzBmNM33XdR6Meuxfp5eg54IYxJvXCx8fHL4F3w36blTdDI4/0WREwMnMBeQ+Qd+YC8h4g78wF5D1A3rEqwBiT6q4ubpRSI+ewuhP0PO/NwcHBExHJZZ8PICI/e73ep7z6zzNPwWP1djhuOp3OfRG5kLROFEXv19fXP49bU6TbYQDa7XZDRF6kUUtEtoFb49YUbh/gOM7YbwqnyG4URQ/PWlQ4ASllNwzDzY2NDX3WwioKmBgeqidgKnioloCp4aE6AmLBQzUExIaH8gtIBA/lFrCTFB7KK2AnDMOrSeGhnAJSg4fyCUgVHsolIHV4KI8AK/BQDgHW4KH4AqzCQwEfiIRheKKUAvjuuu7m2tpakPdMmcYYI1rre0EQ1LPo9w82qyNziMdZ3AAAAABJRU5ErkJggg=="> <img src="https://img.shields.io/badge/AWS-deploys-F29100.svg?logo=amazon"> |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| __Services__     | Amazon S3, Lambda, DynamoDB, SNS, SQS                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| __Integrations__ | AWS SDK, Terraform, AWS CLI, Cloud Pods                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| __Categories__   | Spring Boot, Testcontainers                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| __Level__        | Intermediate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| __Works on__     | LocalStack v3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |


## Purpose

This repository is meant to support the Cloud Pods blog post.

## Architecture Overview


![Diagram](app_diagram.png)

## Prerequisites

To run this sample you will need:

- [Maven 3.8.5](https://maven.apache.org/install.html) & [Java 17](https://www.java.com/en/download/help/download_options.html)
- [Docker](https://docs.docker.com/get-docker/) - for running LocalStack


## Cloud Pods

To better understand everything about state management in LocalStack please refer to the dedicated documentation section: https://docs.localstack.cloud/user-guide/state-management/.

### Quick Setup

You can refer to the original repository for more information on how to run the full sample: https://github.com/localstack-samples/sample-shipment-list-demo-lambda-dynamodb-s3.

For the quick version, follow these steps:
- `cd shipment-picture-lambda-validator`
- `mvn clean package shade:shade`
- In the root folder, start LocalStack with the `LOCALSTACK_AUTH_TOKEN` pre-configured:

```bash
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
make start
make ready
```

- Deploy the infrastructure:

```bash
make deploy
```

Now you should have all your resources created in your LocalStack instance.

### Saving the snapshot

You'll need your Auth Token:

```
export LOCALSTACK_AUTH_TOKEN="YOUR_AUTH_TOKEN"
```

To save your remote cloud pod:

```
localstack pod save <pod_name>
```

To save your instance’s state locally:

```
localstack state export <my-state>
```

## Further reading

- Testcontainers LocalStack module - https://java.testcontainers.org/modules/localstack/
- LocalStack user guides - https://docs.localstack.cloud/user-guide/
- Testcontainers workshop - https://github.com/testcontainers/workshop







