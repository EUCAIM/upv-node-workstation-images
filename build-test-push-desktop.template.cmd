setlocal
set V1=2.3
set V2=2.4

set CUDA_VERSION=
REM Uncomment for building with CUDA
REM set CUDA_VERSION=cuda10

set AI_TOOL=tensorflow
REM Uncomment for building with pytorch
REM set AI_TOOL=pytorch

REM =========================================== Building all the images ===========================================
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc:%V1%%CUDA_VERSION% ^
             --build-arg CUDA_VERSION=%CUDA_VERSION% --build-arg AI_TOOL=%AI_TOOL% ^
             ubuntu_python_xxxxx_desktop_vnc
pause
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc_sshd:%V2%%CUDA_VERSION% ^
             --build-arg CUDA_VERSION=%CUDA_VERSION% --build-arg AI_TOOL=%AI_TOOL% ^
             ubuntu_python_xxxxx_desktop_vnc_sshd

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
           -e GUACAMOLE_CONNECTION_NAME=testing-ubuntu_python_%AI_TOOL%_desktop_vnc_sshd  ^
           -e GATEWAY_PORTS=true ^
           -e TCP_FORWARDING=true ^
           --name testing01 ^
           chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc_sshd:%V2%%CUDA_VERSION%

pause
docker logs testing01
REM Test VNC service: run a VNC client (tightVNC or tigerVNC) and connect to localhost:15900.
REM Test file transfer: run SSH client and connect to localhost:3322
pause
docker stop testing01

REM ====================================== Uploading the images to registry ======================================
pause
docker login -u registryuser chaimeleon-eu.i3m.upv.es:10443
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc:%V1%%CUDA_VERSION%
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc_sshd:%V2%%CUDA_VERSION%
docker logout chaimeleon-eu.i3m.upv.es:10443

REM ====================================== Removing local images ======================================
pause
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc_sshd:%V2%%CUDA_VERSION%
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_%AI_TOOL%_desktop_vnc:%V1%%CUDA_VERSION%
           