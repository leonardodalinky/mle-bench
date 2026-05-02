#!/bin/bash
# Fake conda wrapper for the DGX Spark mlebench-env image.
# NGC PyTorch containers already ship the GPU-capable torch stack in
# /usr/bin/python3 — no real conda env needed. This shim exists only so
# the scider agent Dockerfile and start.sh (which reference
# ``conda run -n agent``, ``conda activate agent``, ``conda clean``)
# don't need to be modified. All operations either execute against the
# system interpreter or no-op.
case "$1" in
  run)
    shift
    while [ "$1" = "-n" ] || [ "$1" = "-p" ] || [ "$1" = "--live-stream" ] || [ "$1" = "--no-capture-output" ]; do
      case "$1" in
        -n|-p) shift 2 ;;
        *) shift ;;
      esac
    done
    exec "$@"
    ;;
  activate|deactivate|init|clean|tos|create|install|remove|update|list)
    exit 0
    ;;
  shell)
    # ``eval "$(conda shell.bash hook)"`` — return a no-op function so
    # the caller's ``conda activate X`` / ``conda deactivate`` become no-ops.
    echo 'conda() { return 0; }'
    ;;
  *)
    exec "$@"
    ;;
esac
