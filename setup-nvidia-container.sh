#!/bin/sh

REQUIREDVERSION="19.03.4"
DOCKERVERSION=$(sudo docker version --format '{{.Client.Version}}')

echo "Docker Client version is $DOCKERVERSION"
echo "Required version is $REQUIREDVERSION"

# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash
version_comp() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

version_comp $REQUIREDVERSION $DOCKERVERSION && MEET_REQUIRTEMENT=true || MEET_REQUIRTEMENT=false

if "${MEET_REQUIRTEMENT}"; then
        echo "Start setup for nvidia-container"
        distribution=$(. /etc/os-release; echo $ID$VERSION_ID) && \
        curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add - && \
        curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list && \
        sudo apt update && sudo apt install -y nvidia-container-runtime && \
        echo "Finish setup"

else
        echo "Please upgrade the Docker version to $REQUIREDVERSION or higher."

fi
