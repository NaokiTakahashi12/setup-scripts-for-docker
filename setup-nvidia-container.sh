#!/bin/sh

REQUIREDVERSION="19.03.4"
DOCKERVERSION=$(sudo docker version --format '{{.Client.Version}}')

echo "Docker Client version is $DOCKERVERSION"
echo "Required version is $REQUIREDVERSION"

UNDER=$(echo "$REQUIREDVERSION" | awk -F '[.]' '{print $1$2$3}')
DOCKERVERSION=$(echo "$DOCKERVERSION" | awk -F '[.]' '{print $1$2$3}')

if [ $DOCKERVERSION -ge $UNDER ]; then
        echo "Start setup for nvidia-container"
        distribution=$(. /etc/os-release; echo $ID$VERSION_ID) && \
        curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add - && \
        curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list && \
        sudo apt update && sudo apt install -y nvidia-container-runtime && \
        echo "Finish setup"

else
        echo "Please upgrade the Docker version to $REQUIREDVERSION or higher."

fi
