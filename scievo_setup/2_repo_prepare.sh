#!/bin/bash

# 去到仓库目录
cd "$(dirname "$0")/.."

# 检查 Git LFS 是否安装, 如果没有安装则安装
if ! command -v git-lfs &> /dev/null
then
    echo "Git LFS could not be found, installing..."
    sudo apt-get install git-lfs
fi


# 初始化 Git LFS 并拉取所有大文件
git lfs install
git lfs fetch --all
git lfs pull

# 如果 Miniconda 未安装, 则安装 Miniconda
if ! command -v conda &> /dev/null
then
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    echo "请运行以下命令以使 conda 在当前 shell 可用:"
    echo '    source ~/miniconda3/bin/activate'
fi


# 安装 mlebench
pip install -e .
