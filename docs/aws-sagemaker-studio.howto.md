# AWS SageMaker Studio setup

## Pre-requisites

The following are outside the scope of this guide, and assumed to be completed
beforehand:

- Install AWS CLI
- Install AWS ECR Docker credential helper
- Update `~/.docker/config.json` to use the ECR credential helper for the ECR
  registry in the AWS account
- Configure credentials for the AWS CLI with proper permissions
- Set up a SageMaker Studio domain in the AWS account
- Create an execution IAM role for SageMaker Studio (will be created as part of
  the default domain bootstrap)

## Pull or build image

Either pull the public image locally for tagging:

```sh
docker pull andreswebs/jupyter-langchain
```

Or build it locally from the Dockerfile in this repo.

```sh
docker build --platform linux/amd64 --tag "<your image tag>" .
## e.g.
# docker build --platform linux/amd64 --tag "andreswebs/jupyter-langchain" .
```

## Push to ECR

```sh
ACCOUNT_ID=$(
    aws sts get-caller-identity \
        --query 'Account' \
        --output text
)

AWS_REGION=$(aws configure get region)

## ensure ECR repo exists with the name
ECR_REPO_NAME="your/jupyter-langchain"
## tag
IMAGE_TAG="latest"

ECR_IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"

docker tag "<your image tag>" "${ECR_IMAGE_URI}"
## e.g.
# docker tag "andreswebs/jupyter-langchain" "${ECR_IMAGE_URI}"

docker push "${ECR_IMAGE_URI}"
```

## Set image in SageMaker

Create domain input file:

```sh
cp ./aws-sagemaker/update-domain-input.example.json ./aws-sagemaker/update-domain-input.json
```

Edit `./aws-sagemaker/update-domain-input.json` and insert the SageMaker domain
ID.

Update the SageMaker Studio domain to use the custom image:

```sh
IMAGE_NAME="jupyter-langchain"

# this is the SageMaker execution role, assumed to be present already;
# look up the arn and insert
ROLE_ARN="<insert>"

aws sagemaker create-image \
    --image-name "${IMAGE_NAME}" \
    --role-arn "${ROLE_ARN}"

aws sagemaker create-image-version \
    --image-name "${IMAGE_NAME}" \
    --base-image "${ECR_IMAGE_URI}"

aws sagemaker create-app-image-config \
    --cli-input-json "file://aws-sagemaker/app-image-config-input.json"

aws sagemaker update-domain \
    --cli-input-json "file://aws-sagemaker/update-domain-input.json"
```
