## Config

To output the default Jupyter Server config to stdout:

```sh
docker run \
    --rm
    --interactive \
    --tty \
    quay.io/jupyter/base-notebook \
    cat /home/jovyan/.jupyter/jupyter_server_config.py
```
