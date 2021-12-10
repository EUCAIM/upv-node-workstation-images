setlocal
set V0=2.0
set V1=2.2
set V2=2.3
REM Uncomment for building with CUDA
REM set TENSOR_IMAGE_TAG=-gpu
REM set CUDA_VERSION=cuda10

REM =========================================== Building all the images ===========================================
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow:%V0%%CUDA_VERSION% ^
             --build-arg TENSOR_IMAGE_TAG=%TENSOR_IMAGE_TAG% --build-arg CUDA_VERSION=%CUDA_VERSION% ^
             ubuntu_python_tensorflow
pause
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc:%V1%%CUDA_VERSION% ^
             --build-arg CUDA_VERSION=%CUDA_VERSION% ^
             ubuntu_python_tensorflow_desktop_vnc
pause
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc_sshd:%V2%%CUDA_VERSION% ^
             --build-arg CUDA_VERSION=%CUDA_VERSION% ^
             ubuntu_python_tensorflow_desktop_vnc_sshd

REM ======================================== Deploying a container to test ========================================
pause
docker run -d --rm -p 15900:5900 -p 3322:22 ^
           -e VNC_PASSWORD="chaimeleon" ^
           -e PASSWORD="chaimeleon" ^
           -e GUACAMOLE_URL=https://chaimeleon-eu.i3m.upv.es/guacamole/ ^
           -e GUACAMOLE_USER="guacamoleuser" ^
           -e GUACAMOLE_PASSWORD="XXXXXXX" ^
           -e GUACD_HOST="10.98.124.259" ^
           -e SSH_ENABLE_PASSWORD_AUTH=true  ^
           -e GATEWAY_PORTS=true ^
           -e TCP_FORWARDING=true ^
           --name testing01 ^
           chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc_sshd:%V2%%CUDA_VERSION%

pause
docker logs testing01
REM Test VNC service: run a VNC client (tightVNC or tigerVNC) and connect to localhost:15900.
REM Test file transfer: run SSH client and connect to localhost:3322
pause
docker stop testing01

REM ====================================== Uploading the images to registry ======================================
pause
docker login -u registryuser chaimeleon-eu.i3m.upv.es:10443
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow:%V0%%CUDA_VERSION%
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc:%V1%%CUDA_VERSION%
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc_sshd:%V2%%CUDA_VERSION%
docker logout chaimeleon-eu.i3m.upv.es:10443

REM ====================================== Removing local images ======================================
pause
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc_sshd:%V0%%CUDA_VERSION%
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_desktop_vnc:%V1%%CUDA_VERSION%
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow:%V2%%CUDA_VERSION%
           