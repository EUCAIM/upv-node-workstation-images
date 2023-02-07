#!/bin/bash

export REGISTRY_HOST=harbor.chaimeleon-eu.i3m.upv.es
export REGISTRY_PATH=/chaimeleon-library-batch/

export CUDA_VERSION=
echo "Do you want to build with CUDA? (y/n)" && read RES
if [ "$RES" == "y" ]; then
    export CUDA_VERSION=cuda10
fi

echo "Which AI tool do you want to include? (tensorflow/pytorch)" && read RES
if [ "$RES" == "tensorflow" ]; then 
    export AI_TOOL=tensorflow
    export TARGET_VERSION=2.2
    export TENSOR_IMAGE_TAG=
    if [ "$CUDA_VERSION" != "" ]; then
        export TENSOR_IMAGE_TAG=-gpu
    fi
elif [ "$RES" == "pytorch" ]; then 
    export AI_TOOL=pytorch
    export BASE_VERSION=2.3
    export TARGET_VERSION=2.4
else 
    echo wrong response; exit
fi


# =========================================== Building all the images ===========================================
docker build -t ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}:${TARGET_VERSION}${CUDA_VERSION} \
             --build-arg TENSOR_IMAGE_TAG=${TENSOR_IMAGE_TAG} --build-arg CUDA_VERSION=${CUDA_VERSION} \
             --build-arg BASE_VERSION=${BASE_VERSION} --build-arg TARGET_VERSION=${TARGET_VERSION} \
             ubuntu_python_$AI_TOOL

# ======================================== Deploying a container to test ========================================
echo "Do you want to run the container for testing? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    echo "OK, when you end the testing write 'exit' to stop and remove the container."
    docker run -it --rm --name testing01 \
               ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}:${TARGET_VERSION}${CUDA_VERSION} bash
fi

# ====================================== Uploading the images to registry ======================================
echo "Do you want to upload the image? (y/n)" && read RES
if [ "$RES" == "y" ]; then 
    RET=999
    while [ $RET != 0 ]; do
        docker push ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}:${TARGET_VERSION}${CUDA_VERSION}
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
        docker rmi ${REGISTRY_HOST}${REGISTRY_PATH}ubuntu_python_${AI_TOOL}:${TARGET_VERSION}${CUDA_VERSION}
    fi
fi
