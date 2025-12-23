#!/bin/bash

cd "$(dirname "$0")/.."


EXP_ID=2025-12-23T03-27-25-GMT_run-group_scievo

python experiments/make_submission.py \
    --metadata runs/${EXP_ID}/metadata.json \
    --output tmp_submission.jsonl

mlebench grade \
    --submission tmp_submission.jsonl \
    --output-dir runs/${EXP_ID}
