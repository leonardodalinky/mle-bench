#!/bin/bash


# python run_agent.py --agent-id scievo --competition-set experiments/splits/scievo_test.txt

# alternative command with GPU config
# python run_agent.py --agent-id scievo/gemini-low-medium --competition-set experiments/splits/low.txt --container-config environment/config/container_configs/gpu.json
python run_agent.py --agent-id scievo/gemini-medium-high --competition-set experiments/splits/low.txt --container-config environment/config/container_configs/gpu.json
# python run_agent.py --agent-id scievo/gemini-medium-high --competition-set experiments/splits/low_rest_gemini.txt --container-config environment/config/container_configs/gpu.json

# python run_agent.py --agent-id scievo/gpt-low-medium --competition-set experiments/splits/low.txt --container-config environment/config/container_configs/gpu.json
# python run_agent.py --agent-id scievo/gpt-medium-high --competition-set experiments/splits/low.txt --container-config environment/config/container_configs/gpu.json
# python run_agent.py --agent-id scievo/gpt-medium-high --competition-set experiments/splits/low_rest_gpt.txt --container-config environment/config/container_configs/gpu.json
