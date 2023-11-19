FROM quay.io/jupyter/base-notebook

ARG ENV_NAME=langchain

USER root

RUN \
    apt-get update && \
    apt-get install --yes --quiet \
        build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ENV_SCRIPT=/usr/local/bin/before-notebook.d/activate-env.sh && \
    echo "#!/bin/bash" > "${ENV_SCRIPT}" && \
    echo "eval \"$(conda shell.bash activate \"${ENV_NAME}\")\"" >> ${ENV_SCRIPT} && \
    chmod +x "${ENV_SCRIPT}"

COPY --chown=${NB_UID}:${NB_GID} environment.yml /tmp/

COPY --chown=${NB_UID}:${NB_GID} jupyter_server_config.py /home/jovyan/.jupyter/

USER ${NB_UID}

RUN \
    mamba env create \
        --prefix "${CONDA_DIR}/envs/${ENV_NAME}" \
        --file /tmp/environment.yml && \
    mamba clean --all --force --yes

RUN \
    "${CONDA_DIR}/envs/${ENV_NAME}/bin/python" -m \
        ipykernel install --user --name="${ENV_NAME}" --display-name="Python 3 (${ENV_NAME})" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "${HOME}"

RUN echo "conda activate ${ENV_NAME}" >> "${HOME}/.bashrc"
