#!/bin/bash

set -e

cd $(dirname "$0")/..

# Check if mlebench-env image exists, if not build it
if ! docker image inspect mlebench-env > /dev/null 2>&1; then
    docker build --platform=linux/amd64 -t mlebench-env -f environment/Dockerfile .
fi

cd $(dirname "$0")/..

export SUBMISSION_DIR=/home/submission
export LOGS_DIR=/home/logs
export CODE_DIR=/home/code
export AGENT_DIR=/home/agent

export AGENT=scider

docker build --platform=linux/amd64 -t $AGENT agents/$AGENT/ --build-arg SUBMISSION_DIR=$SUBMISSION_DIR --build-arg LOGS_DIR=$LOGS_DIR --build-arg CODE_DIR=$CODE_DIR --build-arg AGENT_DIR=$AGENT_DIR
