setlocal
set V0=2.0

set TENSOR_IMAGE_TAG=
set CUDA_VERSION=
REM Uncomment for building with CUDA
REM set TENSOR_IMAGE_TAG=-gpu
REM set CUDA_VERSION=cuda10

set AI_TOOL=tensorflow
REM Uncomment for building with pytorch
REM set AI_TOOL=pytorch

REM =========================================== Building all the images ===========================================
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%:%V0%%CUDA_VERSION% ^
             --build-arg TENSOR_IMAGE_TAG=%TENSOR_IMAGE_TAG% --build-arg CUDA_VERSION=%CUDA_VERSION% ^
             ubuntu_python_%AI_TOOL%

REM ======================================== Deploying a container to test ========================================
pause
docker run -d --rm --name testing01 ^
           chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%:%V0%%CUDA_VERSION%

pause
docker logs testing01
REM Test VNC service: run a VNC client (tightVNC or tigerVNC) and connect to localhost:15900.
REM Test file transfer: run SSH client and connect to localhost:3322
pause
docker stop testing01

REM ====================================== Uploading the images to registry ======================================
pause
docker login -u registryuser chaimeleon-eu.i3m.upv.es:10443
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%:%V0%%CUDA_VERSION%
docker logout chaimeleon-eu.i3m.upv.es:10443

REM ====================================== Removing local images ======================================
pause
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%:%V0%%CUDA_VERSION%
           