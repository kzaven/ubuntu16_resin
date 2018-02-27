#########################
# Ubuntu 16.04 Resin.io #
#########################
FROM aarch64/ubuntu:16.04

RUN apt-get update
RUN apt-get install -y \
    gcc \
    g++ \ 
    software-properties-common \
    python-software-properties \
    wget \
    vim \
    git \
    tar \
    bzip2 \ 
    unzip \
    sudo \
    python3-pip

WORKDIR /L4T

RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/Tegra210_Linux_R28.1.0_aarch64.tbz2 && tar -xvf Tegra210_Linux_R28.1.0_aarch64.tbz2

WORKDIR /L4T/dpkg

RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/libcudnn6_6.0.21-1+cuda8.0_arm64.deb
RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/nv-gie-repo-ubuntu1604-ga-cuda8.0-trt2.1-20170614_1-1_arm64.deb
RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/cuda-repo-l4t-8-0-local_8.0.84-1_arm64.deb

# Install L4T 28.1
RUN cd /L4T/Linux_for_Tegra  && ./apply_binaries.sh -r /

# Fix ld path to CUDA libraries
RUN echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf

RUN dpkg -R --install /L4T/dpkg/*.deb

RUN apt-get update && apt-get install -y \
    libcudnn6 \
    cuda-samples-8-0 \
    nv-gie-repo-ubuntu1604-ga-cuda8.0-trt2.1-20170614

RUN dpkg -i /var/cuda-repo-8-0-local/cuda-command-line-tools-8-0_8.0.84-1_arm64.deb
RUN dpkg -i /var/nv-gie-repo-ga-cuda8.0-trt2.1-20170614/libcudnn6-dev_6.0.21-1+cuda8.0_arm64.deb
RUN ln -sf /usr/local/cuda-8.0 /usr/local/cuda

WORKDIR /tmp

#Install git-lfs, docker and docker-compose
COPY scripts /tmp/scripts
RUN /bin/bash /tmp/scripts/install_gitlfs.sh
RUN /bin/bash /tmp/scripts/install_docker.sh
RUN pip3 install docker-compose
RUN rm -rf scripts gocode go-linux-arm64-bootstrap*

#SSH key to clone from github
RUN mkdir -p /root/.ssh
COPY ssh/id_rsa /root/.ssh/id_rsa
COPY ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 400 /root/.ssh/id*
RUN apt-get update && apt-get install -y ssh
RUN eval `ssh-agent -s` && ssh-add /root/.ssh/id_rsa
RUN ssh-keyscan github.com >>~/.ssh/known_hosts

WORKDIR /root

#Clone needed git repos
RUN git clone git@github.com:Skycatch/node-discover-app.git 
RUN git clone git@github.com:Skycatch/python-discover-ml.git \
    && cd python-discover-ml \
    && git lfs install \
    && git-lfs pull \
    && mkdir models \
    && cd models \
    && git clone git@github.com:tensorflow/models.git

#Configurinng docker
COPY daemon.json /

ENV INITSYSTEM on
