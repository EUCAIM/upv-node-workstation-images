# workstation-images

### Build, test and push
If you have made some change in any of the images, please open the script file (`build-test-push--XXXXX.sh`) according to the image you change and increase the version in the appropiate environment variable.
If you want to apply the change also to the images based on the changed image you will have to increase the version also in them.
Those are the dependencies:
```
 - ubuntu_python --> ubuntu_python_pytorch |-> ubuntu_python_pytorch_desktop_vnc --> ubuntu_python_pytorch_desktop_vnc_sshd
                                           |-> ubuntu_python_pytorch_jupyter
 
 - ubuntu_python_tensorflow |-> ubuntu_python_tensorflow_desktop_vnc --> ubuntu_python_tensorflow_desktop_vnc_sshd
                            |-> ubuntu_python_tensorflow_jupyter
```
Then simply run the script of the images you want to build.
```
chmod +x build-test-push--*.sh
./build-test-push--ubuntu_python.sh
```
You will be interactively asked to select build with o without CUDA, which AI tool to include, if you want to test, upload, etc.


## How to design a workstation image for the CHAIMELEON platform
This is a guide to create a container image for a workstation to be deployed by users in the CHAIMELEON platform.

### Template
This is a template for the dockerfile (some details are explained in the next chapters):
```
## Base image:
FROM ...

############## Things done by the root user ##############
USER root
# Installation of tools and requirements:
RUN apt-get install ...
RUN pip install ...
...

# create the user (and group) "chaimeleon"
RUN groupadd -g 1000 chaimeleon && \
    useradd --create-home --shell /bin/bash --uid 1000 --gid 1000 chaimeleon 
# Default password "chaimeleon" for chaimeleon user. 
RUN echo "chaimeleon:chaimeleon" | chpasswd

############### Now change to normal user ################
USER chaimeleon:chaimeleon

# create the directories where some volumes will be mounted
RUN mkdir -p /home/chaimeleon/datasets && \
    mkdir -p /home/chaimeleon/persistent-home && \
    mkdir -p /home/chaimeleon/persistent-shared-folder
    
# Copy of the application files into the container:
ADD ...

WORKDIR /home/chaimeleon
```

### There is no Internet access in run time
Things like "apt get", "pip install", "git clone", or any download from a server out of the platform must be in the dockerfile (image build time) not in init scripts (run time). It is usually needed to install requirements and tools during the image building. Once the image is built and moved to the CHAIMELEON repository, it will be used to create containers running within the platform, with no Internet access, and so, any initial script that try to download anything from outside will fail. The user only will be able to user browsers and tools like that to access internal services.

### "chaimeleon" user 
The main process of the container will be run by the user with uid 1000 and gid 1000. So you should create it in the OS and use it to create any directory structure (like the directories for later mounting of volumes) or copy your application files into the container.  
The name is not important, but we recommend use "chaimeleon" to have an homogeneous environment whatever the type of workstation the user select for his/her work session.

The root user is only used in image build time, after the `USER` instruction all the processes will run with the normal user including any init script, the shell accessed by SSH, the desktop accessed by Guacamole or any web service (Jupyter Notebook, RStudio) for provide a web interface for the user.  
The normal user should not be included into sudoers, the image repository admin will control that (only in special cases the user can be added in sudoers for a concrete and safe command, never for any command).

More details and reasons for that in [helm chart guide](https://github.com/chaimeleon-eu/helm-chart-common).

#### Setting the password for "chaimeleon" user
The line with `chpasswd` for setting the password is only needed if it is required that the user can log into the OS (through SSH for example).
You should include that if you want to install sshd and let the user login with this account.
Also you should change it later in an init script by one randomly generated or one set by user in an environment variable 
In both cases the final password is known at run time and this is why it must be changed in an init script, for example with:  
``` 
USER=chaimeleon
PREVIOUS_PASSWORD=chaimeleon
PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;)
echo -e "$PREVIOUS_PASSWORD\n$PASSWORD\n$PASSWORD" | (passwd $USER)
```

For adding an init script you can do this: 
```
# Add entrypoint script
# (useful if we want to do things with environment variables defined by the user)
ADD run.sh /home/chaimeleon/.init/run.sh

ENTRYPOINT ["/home/chaimeleon/.init/run.sh"]
```

### Directories for mounting volumes
Finally some directories should be created in the user home where the volumes (datasets, persistent-home, persistent-shared-folder) will be mounted when the container is created into the platform.


### Include vnc server
...
