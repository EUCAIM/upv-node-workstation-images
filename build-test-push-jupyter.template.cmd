setlocal
set V=1.2

set CUDA_VERSION=
REM Uncomment for building with CUDA
REM set CUDA_VERSION=cuda10

set AI_TOOL=tensorflow
REM Uncomment for building with pytorch
REM set AI_TOOL=pytorch

REM =========================================== Building all the images ===========================================
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_jupyter:%V%%CUDA_VERSION% ^
             --build-arg CUDA_VERSION=%CUDA_VERSION% --build-arg AI_TOOL=%AI_TOOL% ^
             ubuntu_python_xxxxx_jupyter

REM ======================================== Deploying a container to test ========================================
pause
docker run -d --rm -p 9888:8888 ^
           -e PASSWORD="chaimeleon" ^
           -e URL_PATH=test-jupyter ^
           --name testing02 ^
           chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_jupyter:%V%%CUDA_VERSION%

pause
docker logs testing02
REM Test jupyter service: open in the browser the URL localhost:9888/test-jupyter/.
pause
docker stop testing02

REM ====================================== Uploading the images to registry ======================================
pause
docker login -u registryuser chaimeleon-eu.i3m.upv.es:10443
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_jupyter:%V%%CUDA_VERSION%
docker logout chaimeleon-eu.i3m.upv.es:10443

REM ====================================== Removing local images ======================================
pause
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_jupyter:%V%%CUDA_VERSION%

           