#######################
# L4T R28.1.0 SOURCES #
#######################
FROM aarch64/ubuntu:16.04

RUN apt-get update && apt-get install -y \
  wget \
  unzip \
  tar \
  vim \
  openssh-server

WORKDIR /L4T

RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/Tegra210_Linux_R28.1.0_aarch64.tbz2 && tar -xvf Tegra210_Linux_R28.1.0_aarch64.tbz2

WORKDIR /L4T/dpkg

RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/libcudnn6_6.0.21-1+cuda8.0_arm64.deb
RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/nv-gie-repo-ubuntu1604-ga-cuda8.0-trt2.1-20170614_1-1_arm64.deb
RUN wget -q http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/cuda-repo-l4t-8-0-local_8.0.84-1_arm64.deb

# Prerequists
RUN apt-get update && apt-get install -y \
  git \
  cmake \
  tar \
  build-essential \
  software-properties-common \
  python3-software-properties

# GCC 7
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y  \
  gcc-7 \
  g++-7

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

## Dev dependencies
#RUN apt-get install -y \
#  libglew-dev \
#  libtiff5-dev \
#  zlib1g-dev \
#  libjpeg-dev \
#  libpng12-dev \
#  libjasper-dev \
#  libavcodec-dev \
#  libavformat-dev \
#  libavutil-dev \
#  libpostproc-dev \
#  libswscale-dev \
#  libeigen3-dev \
#  libtbb-dev \
#  libgtk2.0-dev \
#  cmake \
#  pkg-config
#
## Python 3
#RUN apt-get install -y \
#  python3-dev \
#  python3-numpy \
#  python3-py \
#  python3-pip \
#  python3-pytest
#
## GStreamer support
#RUN apt-get install -y \
#  libgstreamer1.0-dev \
#  libgstreamer-plugins-base1.0-dev
#
## Prerequists
#RUN add-apt-repository universe
#RUN add-apt-repository ppa:openjdk-r/ppa
#
## General Dependencies
#RUN apt-get update && apt-get install -y \
#  libprotobuf-dev \
#  libleveldb-dev \
#  libsnappy-dev \
#  libhdf5-serial-dev \
#  protobuf-compiler \
#  libtbb2 \
#  libtiff5 \
#  libjasper1
#
##Install OpenCV and Tensorflow Python3.6
#COPY tensorflow-1.3.0-cp36-cp36m-linux_aarch64.whl /tmp/
#COPY scripts /tmp/scripts
#RUN /bin/bash /tmp/scripts/install_python-3.6.sh
#RUN /bin/bash /tmp/scripts/install_protobuf-2.6.sh
#RUN /bin/bash /tmp/scripts/install_opencv_tensorflow.sh
#
ENV INITSYSTEM on
