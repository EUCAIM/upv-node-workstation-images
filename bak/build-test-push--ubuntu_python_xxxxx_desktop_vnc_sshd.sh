#!/bin/bash

export REGISTRY_HOST=harbor.chaimeleon-eu.i3m.upv.es
export REGISTRY_PATH=/chaimeleon-library/

export CUDA_VERSION=
echo "Do you want to build with CUDA? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    export CUDA_VERSION=cuda10
fi

echo "Which AI tool do you want to include? (tensorflow/pytorch)" && read RES
if [ "$RES" == "tensorflow" ]; then 
    export AI_TOOL=tensorflow
    export BASE_IMAGE_VERSION=2.2
    export VNC_IMAGE_VERSION=2.4
    export TARGET_VERSION=2.5
elif [ "$RES" == "pytorch" ]; then 
    export AI_TOOL=pytorch
    export BASE_IMAGE_VERSION=2.4
    export VNC_IMAGE_VERSION=2.5
    export TARGET_VERSION=2.6
else 
    echo wrong response; exit
fi

# =========================================== Building all the images ===========================================
docker build -t ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc:${VNC_IMAGE_VERSION}${CUDA_VERSION} \
             --build-arg CUDA_VERSION=$CUDA_VERSION --build-arg AI_TOOL=${AI_TOOL} --build-arg AI_TOOL_VERSION=$BASE_IMAGE_VERSION \
             --build-arg TARGET_VERSION=$VNC_IMAGE_VERSION \
             ubuntu_python_xxxxx_desktop_vnc

echo "Continue building the second image? (y/n)" && read RES
if [ "$RES" != "y" ]; then exit; fi
docker build -t ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc_sshd:${TARGET_VERSION}${CUDA_VERSION} \
             --build-arg CUDA_VERSION=$CUDA_VERSION --build-arg AI_TOOL=${AI_TOOL} --build-arg AI_TOOL_VERSION=$VNC_IMAGE_VERSION \
             --build-arg TARGET_VERSION=$TARGET_VERSION \
             ubuntu_python_xxxxx_desktop_vnc_sshd

# ======================================== Deploying a container to test ========================================
echo "Do you want to run the container for testing? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    docker run -d --rm -p 15900:5900 -p 3322:22 \
               -e VNC_PASSWORD="chaimeleon" \
               -e PASSWORD="chaimeleon" \
               -e GUACAMOLE_URL=https://chaimeleon-eu.i3m.upv.es/guacamole/ \
               -e GUACAMOLE_USER="guacamoleuser" \
               -e GUACAMOLE_PASSWORD="XXXXXXXXXXXX" \
               -e GUACD_HOST="10.98.114.250" \
               -e SSH_ENABLE_PASSWORD_AUTH=true \
               -e GUACAMOLE_CONNECTION_NAME=testing-ubuntu_python_${AI_TOOL}_desktop_vnc_sshd \
               -e GATEWAY_PORTS=true \
               -e TCP_FORWARDING=true \
               --name testing01 \
               ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc_sshd:${TARGET_VERSION}${CUDA_VERSION}

    echo "Continue showing the log? (y/n)" && read RES
    if [ "$RES" != "y" ]; then exit; fi
    docker logs testing01
    echo "Test VNC service: run a VNC client (tightVNC or tigerVNC) and connect to localhost:15900."
    echo "Test file transfer: run SSH client and connect to localhost:3322"
    
    echo "Continue stopping the container? (y/n)" && read RES
    if [ "$RES" != "y" ]; then exit; fi
    docker stop testing01
fi

# ====================================== Uploading the images to registry ======================================
echo "Do you want to upload the images? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    RET=999
    while [ $RET != 0 ]; do
        docker push ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc:${VNC_IMAGE_VERSION}${CUDA_VERSION}
        RET=$?
        if [ $RET != 0 ]; then
            echo "Uploading error. Do you want to login? (y/n)" && read RES
            if [ "$RES" == "y" ]; then 
                docker login $REGISTRY_HOST
            else
                echo "Abort upload? (y/n)" && read RES
                if [ "$RES" == "y" ]; then RET=0; fi
            fi
        else
            docker push ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc_sshd:${TARGET_VERSION}${CUDA_VERSION}
        fi
    done
    echo "Do you want to logout? (y/n)" && read RES
    if [ "$RES" == "y" ]; then 
        docker logout $REGISTRY_HOST
    fi

    # ====================================== Removing local images ======================================
    echo "Do you want to remove the local images? (y/n)" && read RES
    if [ "$RES" == "y" ]; then
        docker rmi ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc_sshd:${TARGET_VERSION}${CUDA_VERSION}
        docker rmi ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_desktop_vnc:${VNC_IMAGE_VERSION}${CUDA_VERSION}
    fi
fi
