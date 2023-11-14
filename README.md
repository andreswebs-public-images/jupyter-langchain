# jupyter-langchain

A Jupyter Notebook server with Langchain pre-installed.

## Run

```sh
export WORKDIR=$(pwd) # <-- set this to whatever you'd like
docker run \
    --rm \
    --interactive \
    --tty \
    --publish 8888:8888 \
    --user root \
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

## Authors

**Andre Silva** [andreswebs](https://github.com/andreswebs)

## References

<https://docs.conda.io/projects/conda/en/latest/commands/index.html>

<https://mamba.readthedocs.io>

<https://jupyter-docker-stacks.readthedocs.io>

<https://github.com/jupyter/docker-stacks/blob/main/images/docker-stacks-foundation/Dockerfile>

<https://jupyter-server.readthedocs.io/en/latest/other/full-config.html>

<https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html>

## Acknowledgements

The [Dockerfile](Dockerfile) is based on this recipe:
<https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html>

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
