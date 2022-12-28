ARG IMAGE_NAME="ubuntu:18.04"
ARG CUDA_VERSION=""
ARG TARGET_VERSION="unkown"

## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG IMAGE_NAME="nvidia/cuda:10.2-runtime-ubuntu18.04"
#ARG CUDA_VERSION="cuda10"

##ARG IMAGE_NAME="nvidia/cuda:10.2-cudnn8-runtime-ubuntu18.04"   It is better not to install cudnn now. It can be included later if needed with other packages, like pyTorch.
##ARG IMAGE_NAME="nvidia/cuda:11.3.1-runtime-ubuntu18.04"     Cuda major version in container must match with the version installed in the host

FROM $IMAGE_NAME

LABEL name="ubuntu_python"
LABEL version="${TARGET_VERSION}$CUDA_VERSION"
LABEL description="Container with ubuntu 18.04 (bionic), python 3.6.9, ${CUDA_VERSION} and other tools."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"

# Get the image up to date and install utility tools
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        bash-completion ca-certificates curl iputils-ping netcat \
        man-db net-tools traceroute vim python-xattr parallel \
        python3-pip gnupg2 xattr pv bsdmainutils  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Install necessary pip packages (first upgrade pip and keyrings because ubuntu package is not always up-to-date)
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade keyrings.alt && \
    pip3 install --no-cache-dir opencv-contrib-python keras && \ 
    pip3 install --no-cache-dir -U scikit-learn && \
    pip3 install --no-cache-dir matplotlib scikit-image pandas pydicom

# Install poetry: popular dependecies manager, and used in the Quibim platform to install dependencies required for the image analysis modules.
# And disable virtual environments (in a container usually there is only one project, one environment)
RUN pip3 install --no-cache-dir poetry && poetry config virtualenvs.create false

#RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo chaimeleon
RUN groupadd -g 1000 chaimeleon && \
    useradd --create-home --shell /bin/bash --uid 1000 --gid 1000 chaimeleon 
# Default password "chaimeleon" for chaimeleon user
# (setting the password is required if we want to install sshd and login with that user)
RUN echo "chaimeleon:chaimeleon" | chpasswd

USER chaimeleon:chaimeleon

## Enable autocompletion
#RUN echo "source /etc/bash_completion" >> /home/chaimeleon/.bashrc
RUN poetry config virtualenvs.create false

# Add dataset preparation script
#ADD downloadEForms.py /chaimeleon/.init/downloadEForms.py
RUN mkdir -p /home/chaimeleon/datasets && \
    mkdir -p /home/chaimeleon/persistent-home && \
    mkdir -p /home/chaimeleon/persistent-shared-folder 

# Add entrypoint script
# (useful if we want to do things with environment variables defined by the user)
ADD run.sh /home/chaimeleon/.init/run.sh

ENTRYPOINT ["/home/chaimeleon/.init/run.sh"]
WORKDIR /home/chaimeleon
