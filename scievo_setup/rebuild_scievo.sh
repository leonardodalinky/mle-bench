#!/bin/bash

cd $(dirname "$0")/..

docker stop $(docker ps -q --filter ancestor=scider) 2>/dev/null
docker rmi -f scider
bash scider_setup/4_build_agent_docker.sh
