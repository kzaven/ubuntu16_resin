#######################
# L4T R28.1.0 SOURCES #
#######################
FROM aarch64/ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    tar \
    bzip2 \
    vim \
    sudo 
WORKDIR /tmp

#install docker and docker-compose
RUN /bin/bash /tmp/scripts/install_docker.sh
RUN pip3 install docker-compose


ENV INITSYSTEM on
