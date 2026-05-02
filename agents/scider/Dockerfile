FROM mlebench-env

# NOTE: We assume that this is a submodule, and the build content is in the root dir of SciDER

# where to put submission.csv, will be extracted
ARG SUBMISSION_DIR
ENV SUBMISSION_DIR=${SUBMISSION_DIR}
# where to put any logs, will be extracted
ARG LOGS_DIR
ENV LOGS_DIR=${LOGS_DIR}
# where to put any code, will be extracted
ARG CODE_DIR
ENV CODE_DIR=${CODE_DIR}
# where to put any other agent-specific files, will not be necessarily extracted
ARG AGENT_DIR
ENV AGENT_DIR=${AGENT_DIR}

RUN mkdir ${LOGS_DIR} ${CODE_DIR} ${AGENT_DIR}

ARG CONDA_ENV_NAME=agent
# NOTE: from submodule
ARG MLE_BENCH_DIR=benchmarks/mlebench/mle-bench

# copy just the requirements file, so that we can cache conda separately from the agent files
COPY ${MLE_BENCH_DIR}/agents/scider/requirements.txt ${AGENT_DIR}/requirements.txt
COPY ${MLE_BENCH_DIR}/agents/scider/start.sh ${AGENT_DIR}/start.sh

# Requirements for opencv
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y && apt-get remove -y tmux

# Install scider's Python deps on top of mlebench-env. We do NOT pin
# torch / torchvision / torchaudio here — the mlebench-env base image
# already installs the right versions (CUDA wheels on aarch64 via
# pytorch.org's cu124 index); reinstalling them in this layer would
# overwrite those with PyPI-default CPU wheels. spacy is already in
# environment/requirements.txt at the base layer, no need to reinstall.
RUN conda run -n ${CONDA_ENV_NAME} pip install -r ${AGENT_DIR}/requirements.txt && \
    conda clean -afy

COPY ${MLE_BENCH_DIR}/agents/scider/additional_notes.txt /home/additional_notes.txt

# Put all the agent files in the expected location. Note: ``model_settings/``
# is required — ``register_defaults_from_yaml`` calls ``ModelCatalog.load()``
# which reads ``model_settings/catalog.yaml`` to resolve model ids from the
# per-bench roles yaml. ``.scider/`` carries skill definitions for the
# experiment agent.
COPY scider/         ${AGENT_DIR}/SciDER/scider/
COPY bench_workflows/ ${AGENT_DIR}/SciDER/bench_workflows/
COPY model_settings/ ${AGENT_DIR}/SciDER/model_settings/
COPY .scider/        ${AGENT_DIR}/SciDER/.scider/
COPY .env            ${AGENT_DIR}/SciDER/

WORKDIR ${AGENT_DIR}/SciDER
