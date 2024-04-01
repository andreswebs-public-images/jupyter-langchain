# jupyter-langchain

A Jupyter Notebook server with Langchain pre-installed.

## Run

```sh
export WORKDIR=$(pwd) # <-- set this to whatever
export OPENAI_API_KEY # <-- set this to the OpenAI API Key
```

```sh
docker run \
    --rm \
    --interactive \
    --tty \
    --publish 8888:8888 \
    --user root \
    --env OPENAI_API_KEY \
    --env NB_UID=$(id -u) \
    --env NB_GID=$(id -g) \
    --volume "${WORKDIR}:/home/jovyan/work" \
    andreswebs/jupyter-langchain
```

## Config

To get the default config:

```sh
docker run \
    --rm
    --interactive \
    --tty \
    quay.io/jupyter/base-notebook \
    cat /home/jovyan/.jupyter/jupyter_server_config.py
```

## AWS SageMaker setup

```sh
ACCOUNT_ID=$(
    aws sts get-caller-identity \
        --query 'Account' \
        --output text
)

REGION=$(aws configure get region)

## ensure repo exists with name
## name
ECR_REPO_NAME="your/jupyter-langchain"
## tag
IMAGE_TAG="latest"

ECR_IMAGE_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"

IMAGE_NAME="jupyter-langchain"

# this is the SageMaker execution role, assumed to be present already
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

## Authors

**Andre Silva** [andreswebs](https://github.com/andreswebs)

## References

<https://docs.conda.io/projects/conda/en/latest/commands/index.html>

<https://mamba.readthedocs.io>

<https://jupyter-docker-stacks.readthedocs.io>

<https://github.com/jupyter/docker-stacks/blob/main/images/docker-stacks-foundation/Dockerfile>

<https://jupyter-server.readthedocs.io/en/latest/other/full-config.html>

<https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html>

<https://github.com/aws-samples/sagemaker-studio-custom-image-samples>

<https://github.com/aws-samples/sagemaker-studio-custom-image-samples/blob/main/DEVELOPMENT.md>

## Acknowledgements

The [Dockerfile](Dockerfile) is based on this recipe:
<https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html>

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
