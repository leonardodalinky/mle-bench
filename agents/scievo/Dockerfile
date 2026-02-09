FROM mlebench-env

# NOTE: We assume that this is a submodule, and the build content is in the root dir of SciEvo

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
COPY requirements.txt ${AGENT_DIR}/requirements.txt

# Requirements for opencv
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y && apt-get remove -y tmux

# create conda environment and install the requirements to it
RUN conda run -n ${CONDA_ENV_NAME} pip install -r ${AGENT_DIR}/requirements.txt && \
    conda run -n ${CONDA_ENV_NAME} pip install torch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 && \
    conda clean -afy

COPY ${MLE_BENCH_DIR}/agents/scievo/additional_notes.txt /home/additional_notes.txt

# put all the agent files in the expected location
COPY scievo/ ${AGENT_DIR}/SciEvo/scievo/
COPY bench_workflows/ ${AGENT_DIR}/SciEvo/bench_workflows/
COPY .env  ${AGENT_DIR}/SciEvo/

WORKDIR ${AGENT_DIR}/SciEvo
