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
    export AI_TOOL_VERSION=2.2
    export TARGET_VERSION=1.3
elif [ "$RES" == "pytorch" ]; then 
    export AI_TOOL=pytorch
    export AI_TOOL_VERSION=2.4
    export TARGET_VERSION=1.4
else 
    echo wrong response; exit
fi

# =========================================== Building all the images ===========================================
docker build -t ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_jupyter:${TARGET_VERSION}${CUDA_VERSION} \
             --build-arg CUDA_VERSION=$CUDA_VERSION --build-arg AI_TOOL=${AI_TOOL} --build-arg AI_TOOL_VERSION=$AI_TOOL_VERSION \
             --build-arg TARGET_VERSION=$TARGET_VERSION \
             ubuntu_python_xxxxx_jupyter

# ======================================== Deploying a container to test ========================================
echo "Do you want to run the container for testing? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    docker run -d --rm -p 9888:8888 \
               -e PASSWORD="chaimeleon" \
               -e URL_PATH=test-jupyter \
               --name testing02 \
               ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_jupyter:${TARGET_VERSION}${CUDA_VERSION}

    echo "Continue showing the log? (y/n)" && read RES
    if [ "$RES" != "y" ]; then exit; fi
    docker logs testing02
    echo "Test jupyter service: open in the browser the URL localhost:9888/test-jupyter/."
    
    echo "Continue stopping the container? (y/n)" && read RES
    if [ "$RES" != "y" ]; then exit; fi
    docker stop testing02
fi

# ====================================== Uploading the images to registry ======================================
echo "Do you want to upload the image? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    RET=999
    while [ $RET != 0 ]; do
        docker push ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_jupyter:${TARGET_VERSION}${CUDA_VERSION}
        RET=$?
        if [ $RET != 0 ]; then
            echo "Uploading error. Do you want to login? (y/n)" && read RES
            if [ "$RES" == "y" ]; then 
                docker login $REGISTRY_HOST
            else
                echo "Abort upload? (y/n)" && read RES
                if [ "$RES" == "y" ]; then RET=0; fi
            fi
        fi
    done
    echo "Do you want to logout? (y/n)" && read RES
    if [ "$RES" == "y" ]; then 
        docker logout $REGISTRY_HOST
    fi

    # ====================================== Removing local images ======================================
    echo "Do you want to remove the local image? (y/n)" && read RES
    if [ "$RES" == "y" ]; then
        docker rmi ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}_jupyter:${TARGET_VERSION}${CUDA_VERSION}
    fi
fi
