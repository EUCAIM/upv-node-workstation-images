ARG TENSOR_IMAGE_TAG
ARG CUDA_VERSION
## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG TENSOR_IMAGE_TAG="-gpu"
#ARG CUDA_VERSION="cuda10"

FROM tensorflow/tensorflow:2.3.1$TENSOR_IMAGE_TAG

LABEL name="ubuntu_python_tensorflow"
LABEL description="Container with ubuntu 18.04 (bionic), python 3.6.9, ${CUDA_VERSION} and tensorflow 2.3.1."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL version="2.0$CUDA_VERSION"

# Get the image up to date and install utility tools
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        bash-completion ca-certificates curl iputils-ping netcat \
        man-db net-tools traceroute vim python-xattr parallel \
        python-pip python3-pip gnupg2 xattr pv bsdmainutils  \
        libsm6 libxrender1 libxext6 libgl1-mesa-glx  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip       # The ubuntu package is not always up-to-date

# Install necessary packages
RUN pip install opencv-contrib-python keras && \ 
    pip install -U scikit-learn && \
    pip install matplotlib scikit-image pandas

# Install poetry: popular dependecies manager, and used in the Quibim platform to install dependencies required for the image analysis modules.
# And disable virtual environments (in a container usually there is only one project, one environment)
RUN pip install poetry && poetry config virtualenvs.create false

#RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo chaimeleon
RUN useradd --create-home --shell /bin/bash --user-group chaimeleon
# Default password "chaimeleon" for chaimeleon user
# (setting the password is required if we want to install sshd and login with that user)
RUN echo "chaimeleon:chaimeleon" | chpasswd

USER chaimeleon:chaimeleon

## Enable autocompletion
#RUN echo "source /etc/bash_completion" >> /home/chaimeleon/.bashrc
RUN poetry config virtualenvs.create false

# Add dataset preparation script
#ADD downloadEForms.py /chaimeleon/.init/downloadEForms.py
RUN mkdir -p /home/chaimeleon/datasets
RUN mkdir -p /home/chaimeleon/persistent-home
RUN mkdir -p /home/chaimeleon/persistent-shared-folder

# Add entrypoint script
# (useful if we want to do things with environment variables defined by the user)
ADD run.sh /home/chaimeleon/.init/run.sh

ENTRYPOINT ["/home/chaimeleon/.init/run.sh"]
WORKDIR /home/chaimeleon
