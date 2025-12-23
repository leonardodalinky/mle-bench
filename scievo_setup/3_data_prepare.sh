#!/bin/bash

# Print this to ~/.kaggle/kaggle.json
mkdir -p ~/.kaggle
echo '{"username":"kelin5","key":"16d896285f55229cf5cb9ee1ad8e7ca4"}' > ~/.kaggle/kaggle.json
chmod 600 ~/.kaggle/kaggle.json

# mlebench prepare --all

mlebench prepare --lite

# mlebench prepare -c <competition-id>

# mlebench prepare -c aerial-cactus-identification