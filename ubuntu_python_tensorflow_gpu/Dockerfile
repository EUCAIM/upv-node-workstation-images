# Specific build arguments for ubuntu 18.04 with gpu (cuda 10.1)
FROM tensorflow/tensorflow:2.3.1-gpu

LABEL name="ubuntu_python_tensorflow_gpu"
LABEL description="Container with ubuntu 18.04 (bionic) distribution with python 3.6.9, gpu usage utilities (cuda 10.1) and tensorflow 2.3.1."
LABEL maintainer="J. Damian Segrelles Quilis (dquilis@dsic.upv.es)"
LABEL version="1.1"

# Get the image up to date and install utility tools
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
        bash-completion ca-certificates curl iputils-ping netcat \
        man-db net-tools traceroute vim python-xattr parallel \
        python-pip python3-pip gnupg2 xattr pv bsdmainutils  \
        libsm6 libxrender1 libxext6 libgl1-mesa-glx  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install necessary packages
RUN pip install opencv-contrib-python keras && \ 
    pip install -U scikit-learn && \
    pip install matplotlib scikit-image pandas

WORKDIR /tmp

# Install poetry: popular dependecies manager, and used in the Quibim platform to install dependencies required for the image analysis modules.
# And disable virtual environments (in a container usually there is only one project, one environment)
RUN pip install poetry && poetry config virtualenvs.create false

# Enable autocompletion
RUN echo "source /etc/bash_completion" >> /root/.bashrc

# Add dataset preparation script
#ADD downloadEForms.py /root/downloadEForms.py

# Add entrypoint script
ADD run.sh /root/run.sh

ENTRYPOINT ["/root/run.sh"]
