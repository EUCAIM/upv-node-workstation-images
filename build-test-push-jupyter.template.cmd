setlocal
set V=1.1
REM Uncomment for building with CUDA
REM set TENSOR_IMAGE_TAG=-gpu
REM set CUDA_VERSION=cuda10

REM =========================================== Building all the images ===========================================
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_jupyter:%V%%CUDA_VERSION% ^
             --build-arg TENSOR_IMAGE_TAG=%TENSOR_IMAGE_TAG% --build-arg CUDA_VERSION=%CUDA_VERSION% ^
             ubuntu_python_tensorflow_jupyter

REM ======================================== Deploying a container to test ========================================
pause
docker run -d --rm -p 98888:8888 ^
           -e PASSWORD="chaimeleon" ^
           -e URL_PATH=test-jupyter ^
           --name testing02 ^
           chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_jupyter:%V2%%CUDA_VERSION%

pause
docker logs testing02
REM Test jupyter service: open in the browser the URL localhost:98888/test-jupyter/.
pause
docker stop testing02

REM ====================================== Uploading the images to registry ======================================
pause
docker login -u registryuser chaimeleon-eu.i3m.upv.es:10443
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_jupyter:%V%%CUDA_VERSION%
docker logout chaimeleon-eu.i3m.upv.es:10443

REM ====================================== Removing local images ======================================
pause
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_jupyter:%V%%CUDA_VERSION%

           