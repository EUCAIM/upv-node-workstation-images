ARG IMAGE_NAME="ubuntu:22.04"
ARG CUDA_VERSION=""
ARG TARGET_VERSION="unknown"

## Uncomment or include in "docker build --build-arg" for building with CUDA
#ARG IMAGE_NAME="nvidia/cuda:11.8.0-runtime-ubuntu22.04"
#ARG CUDA_VERSION="cuda11"

##ARG IMAGE_NAME="nvidia/cuda:10.2-cudnn8-runtime-ubuntu18.04"   It is better not to install cudnn now. It can be included later if needed with other packages, like pyTorch.
##ARG IMAGE_NAME="nvidia/cuda:11.3.1-runtime-ubuntu18.04"     Cuda major version in container must match with the version installed in the host

FROM $IMAGE_NAME

LABEL name="ubuntu-python"
LABEL version="${TARGET_VERSION}$CUDA_VERSION"
LABEL description="Container with ubuntu 22.04, python 3.10.6, ${CUDA_VERSION} and other tools."
LABEL authorization="This Dockerfile is intended to build a container image that will be publicly accessible in the platform images repository."

############## Things done by the root user ##############
USER root

# To avoid interaction when installing some packages
ARG DEBIAN_FRONTEND=noninteractive

# Get the image up to date and install utility tools
# 2023-02-07 Added python3-opencv now installed with apt because pip package (opencv-contrib-python) compiles from source and takes about 30 min, 
#            and may require apt-package build-essential.
# 2023-10-18 It seems now the base image not includes the nvidia-smi command. Added nvidia-utils-525 just for that.
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        bash-completion ca-certificates curl iputils-ping netcat \
        man-db net-tools traceroute vim parallel unzip zip 7zip unrar \
        python3-pip python3-venv python3-virtualenv gnupg2 xattr pv bsdmainutils python3-opencv && \
    if [ ! -z "$CUDA_VERSION" ] ; then apt-get -y install --no-install-recommends nvidia-utils-525; fi  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3 /usr/bin/python
# That symbolic link python -> python3 can avoid possible errors to newbies ("python command not found"),
# although can also cause errors in old python2 scripts, but for now we don't have python2 nor old python2 scripts.

# Install required python packages (basic libraries for working with datasets)
# First upgrade some essential packages pip and keyrings.alt to avoid later warnings/errors, because ubuntu packages is not always up-to-date
# python-gdcm, pylibjpeg and pylibjpeg-libjpeg required (by pydicom) for visualizing some dicom files which use that format in the pixel array.
RUN pip3 install --no-cache-dir --upgrade pip keyrings.alt && \
    pip3 install --no-cache-dir \
        tqdm argparse \
        keras scipy matplotlib scikit-learn scikit-image pandas \
        pydicom python-gdcm pylibjpeg pylibjpeg-libjpeg \
        dicom2nifti simpleitk h5py nibabel

# Install poetry: popular dependecies manager, and used in the Quibim platform to install dependencies required for the image analysis modules.
# And disable virtual environments (in a container usually there is only one project, one environment)
RUN pip3 install --no-cache-dir poetry && poetry config virtualenvs.create false

#RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ds
RUN groupadd -g 1000 ds && \
    useradd --create-home --shell /bin/bash --uid 1000 --gid 1000 ds
# Default password "password" for ds user
# (setting the password is required if we want to install sshd and login with that user)
RUN echo "ds:password" | chpasswd

# Add entrypoint script
# (useful if we want to do things with environment variables defined by the user)
ADD run.sh /home/ds/.init/run.sh
RUN chmod +x /home/ds/.init/run.sh

COPY --chown=ds:ds rootfs/home/ds /home/ds/
RUN chmod +x /home/ds/.local/bin/install-upload-result


############### Now change to normal user ################
USER ds:ds

# Install udocker to allow the user to launch Docker containers without being root
RUN mkdir -p /home/ds/.local/lib \
    && cd /home/ds/.local/lib \
    && curl -L https://github.com/indigo-dc/udocker/releases/download/1.3.17/udocker-1.3.17.tar.gz > udocker-1.3.17.tar.gz \
    && tar zxvf udocker-1.3.17.tar.gz \
    && export PATH=/home/ds/.local/lib/udocker-1.3.17/udocker:$PATH \
    && sed -i '1s/python/python3/' /home/ds/.local/lib/udocker-1.3.17/udocker/maincmd.py \
    && udocker install \
    && rm udocker-1.3.17.tar.gz

ENV PATH="${PATH}:/home/ds/.local/lib/udocker-1.3.17/udocker"

## Enable autocompletion
#RUN echo "source /etc/bash_completion" >> /home/ds/.bashrc
RUN poetry config virtualenvs.create false

# Create the directories where some volumes will be mounted
RUN mkdir -p /home/ds/datasets && \
    mkdir -p /home/ds/persistent-home && \
    mkdir -p /home/ds/persistent-shared-folder

ENTRYPOINT ["/home/ds/.init/run.sh"]
WORKDIR /home/ds
