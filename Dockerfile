FROM quay.io/jupyter/base-notebook

ARG TARGETOS="linux"
ARG TARGETARCH="amd64"
ARG ENV_NAME="langchain"

USER root

RUN \
    apt-get update && \
    apt-get install --yes --quiet \
        build-essential \
        git \
        curl \
        wget \
        zip \
        unzip \
        gettext-base \
        lsb-core \
        jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN \
    if [ "${TARGETARCH}" = "amd64" ]; then export AWS_ARCH="x86_64" ; fi && \
    if [ "${TARGETARCH}" = "arm64" ]; then export AWS_ARCH="aarch64" ; fi && \
    curl \
        --fail \
        --silent \
        --location \
        --output "awscliv2.zip" \
        "https://awscli.amazonaws.com/awscli-exe-${TARGETOS}-${AWS_ARCH}.zip" && \
    unzip -qq awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws awscliv2.zip

RUN ENV_SCRIPT=/usr/local/bin/before-notebook.d/activate-env.sh && \
    echo "#!/usr/bin/env bash" > "${ENV_SCRIPT}" && \
    echo "eval \"$(conda shell.bash activate \"${ENV_NAME}\")\"" >> "${ENV_SCRIPT}" && \
    chmod +x "${ENV_SCRIPT}"

COPY --chown=${NB_UID}:${NB_GID} environment.yml /tmp/

COPY --chown=${NB_UID}:${NB_GID} jupyter_server_config.py /home/jovyan/.jupyter/

COPY --from=mikefarah/yq /usr/bin/yq /usr/bin/yq

RUN chown -R "${NB_UID}:${NB_GID}" /home/jovyan

USER jovyan

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
