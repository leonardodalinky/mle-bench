#!/bin/bash

cd $(dirname "$0")/..

docker stop $(docker ps -q --filter ancestor=scievo) 2>/dev/null
docker rmi -f scievo
bash scievo_setup/4_build_agent_docker.sh
