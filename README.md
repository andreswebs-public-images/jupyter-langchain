# jupyter-langchain

A Jupyter Notebook server container image with Langchain and Deno pre-installed.

This project can be used to run a custom image on AWS SageMaker. See this
[guide](docs/aws-sagemaker.howto.md) for more information.

## Run locally

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
