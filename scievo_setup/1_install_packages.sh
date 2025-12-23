#!/bin/bash

# 1. 首先检查是否以 root 用户身份运行脚本，否则退出
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# 2. 检查 docker 是否已安装，如果未安装则进行安装
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    
    # Set up Docker's apt repository
    sudo apt update
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources
    sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    
    # Install Docker packages
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    echo "Docker installation completed successfully"
else
    echo "Docker is already installed"
fi

# 3. 检查 sysbox 是否已安装，如果未安装则进行安装
if ! command -v sysbox-runc &> /dev/null; then
    echo "Sysbox is not installed. Installing Sysbox..."
    
    # Download the latest Sysbox package
    SYSBOX_VERSION="0.6.7"
    SYSBOX_PKG="sysbox-ce_${SYSBOX_VERSION}-0.linux_amd64.deb"
    SYSBOX_URL="https://downloads.nestybox.com/sysbox/releases/v${SYSBOX_VERSION}/${SYSBOX_PKG}"
    EXPECTED_CHECKSUM="b7ac389e5a19592cadf16e0ca30e40919516128f6e1b7f99e1cb4ff64554172e"
    
    echo "Downloading Sysbox..."
    wget "${SYSBOX_URL}"
    
    # Verify checksum
    echo "Verifying Sysbox package checksum..."
    ACTUAL_CHECKSUM=$(sha256sum "${SYSBOX_PKG}" | awk '{print $1}')
    if [ "${ACTUAL_CHECKSUM}" != "${EXPECTED_CHECKSUM}" ]; then
        echo "ERROR: Checksum verification failed!"
        echo "Expected: ${EXPECTED_CHECKSUM}"
        echo "Actual:   ${ACTUAL_CHECKSUM}"
        exit 1
    fi
    echo "Checksum verified successfully"
    
    # Stop and remove all Docker containers
    echo "Stopping and removing Docker containers..."
    docker rm $(docker ps -a -q) -f 2>/dev/null || true
    
    # Install jq and Sysbox
    echo "Installing jq..."
    sudo apt-get install -y jq
    
    echo "Installing Sysbox..."
    sudo apt-get install -y "./${SYSBOX_PKG}"

    # remove
    rm -f "./${SYSBOX_PKG}"
    
    # Verify Sysbox installation
    echo "Verifying Sysbox installation..."
    sudo systemctl status sysbox -n5
    
    echo "Sysbox installation completed successfully"
else
    echo "Sysbox is already installed"
fi


# 4. 安装 NVIDIA Container Toolkit
if ! command -v nvidia-container-toolkit &> /dev/null; then
    echo "NVIDIA Container Toolkit is not installed. Installing NVIDIA Container Toolkit..."
    
    # Install prerequisites
    echo "Installing prerequisites..."
    sudo apt-get update && sudo apt-get install -y --no-install-recommends \
       curl \
       gnupg2
    
    # Configure the production repository
    echo "Configuring the production repository..."
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null
    
    # Update the packages list from the repository
    echo "Updating packages list..."
    sudo apt-get update
    
    # Install the NVIDIA Container Toolkit packages
    echo "Installing NVIDIA Container Toolkit packages..."
    export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.1-1
    sudo apt-get install -y \
        nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
        nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
        libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
        libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}
    
    echo "NVIDIA Container Toolkit installation completed successfully"
else
    echo "NVIDIA Container Toolkit is already installed"
fi

