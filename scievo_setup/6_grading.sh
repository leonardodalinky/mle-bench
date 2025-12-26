#!/bin/bash

cd "$(dirname "$0")/.."


# EXP_ID=2025-12-24T11-26-49-GMT_run-group_scievo_gpt
EXP_ID=tmp_gpt

python experiments/make_submission.py \
    --metadata runs/${EXP_ID}/metadata.json \
    --output tmp_submission.jsonl

mlebench grade \
    --submission tmp_submission.jsonl \
    --output-dir runs/${EXP_ID}
