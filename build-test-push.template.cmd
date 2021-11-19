setlocal
set V0=2.0
set V1=2.0
set V2=2.1

REM =========================================== Building all the images ===========================================
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu:%V0% ubuntu_python_tensorflow_gpu
pause
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc:%V1% ubuntu_python_tensorflow_gpu_desktop_vnc
pause
docker build -t chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc_sshd:%V2% ubuntu_python_tensorflow_gpu_desktop_vnc_sshd

REM ======================================== Deploying a container to test ========================================
pause
docker run -d --rm -p 15900:5900 -p 3322:22 ^
           -e USER="tensor" ^
           -e PASSWORD="tensor" ^
           -e GUACAMOLE_URL=https://chaimeleon-eu.i3m.upv.es/guacamole/ ^
           -e GUACAMOLE_USER="guacamoleuser" ^
           -e GUACAMOLE_PASSWORD="XXXXXXX" ^
           -e GUACD_HOST="10.98.124.259" ^
           -e SSH_ENABLE_PASSWORD_AUTH=true  ^
           -e GATEWAY_PORTS=true ^
           -e TCP_FORWARDING=true ^
           --name testing01 ^
           chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc_sshd:%V2%

pause
docker logs testing01
REM Test VNC service: run a VNC client (tightVNC or tigerVNC) and connect to localhost:15900.
REM Test file transfer: run SSH client and connect to localhost:3322
pause
docker stop testing01

REM ====================================== Uploading the images to registry ======================================
pause
docker login -u registryuser chaimeleon-eu.i3m.upv.es:10443
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu:%V0%
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc:%V1%
docker push chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc_sshd:%V2%
docker logout chaimeleon-eu.i3m.upv.es:10443

REM ====================================== Removing local images ======================================
pause
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc_sshd:%V0%
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu_desktop_vnc:%V1%
docker rmi chaimeleon-eu.i3m.upv.es:10443/chaimeleon-library/ubuntu_python_tensorflow_gpu:%V2%
           