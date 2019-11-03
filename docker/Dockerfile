FROM ubuntu:16.04
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>

## RESOURCES
##
## Jamie Iles <jamie@jamieiles.com>
## https://www.jamieiles.com/posts/quartus-docker/
##
## Matt Ownby
## http://my-cool-projects.blogspot.com/2018/10/how-to-dockerize-intel-quartus-1801.html

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

ARG MIRROR=http://download.altera.com/akdlm/software/acdsinst/16.1/196/ib_installers/
ARG QUARTUS=QuartusLiteSetup-16.1.0.196-linux.run
ARG QUARTUS_UPDATE=QuartusSetup-16.1.2.203-linux.run
ARG DEVICE_FILES="cyclonev-16.1.0.196.qdz cyclone-16.1.0.196.qdz"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        lib32ncurses5-dev \
        libc6:i386 \
        libcrypto++9v5 \
        libfontconfig1 \
        libglib2.0-0 \
        libncurses5:i386 \
        libsm6 \
        libssl-dev \
        libstdc++6:i386 \
        libxext6:i386 \
        libxft2:i386 \
        libxrender1 \
        libzmq3-dev \
        locales \
        make \
        openjdk-8-jdk \
        pkg-config \
        unixodbc-dev \
        wget \
        xauth \
        xvfb

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN cd /tmp && wget -q $MIRROR$QUARTUS && \
        wget -q $MIRROR$QUARTUS_UPDATE && \
        chmod +x $QUARTUS_UPDATE && \
        for DEV_FILE in $DEVICE_FILES; do wget -q $MIRROR$DEV_FILE; done && \
        chmod +x $QUARTUS && \
        ./$QUARTUS --mode unattended --installdir /opt/altera/ && \
        rm /tmp/* /opt/altera/uninstall -rf

# these files conflict with the Ubuntu versions and cause random segfaults
RUN rm /opt/altera/quartus/linux64/libccl_curl_drl.so \
        /opt/altera/quartus/linux64/libcrypto.so.1.0.0 \
        /opt/altera/quartus/linux64/libcurl.so.4 \
        /opt/altera/quartus/linux64/libssl.so.1.0.0


## TODO rm
# RUN apt-get install -y   \
#             tzdata \
#             locales \
#             build-essential \
#             flex \
#             bison \
#             libncurses5
# 
# ## zephyr setup
# RUN apt-get install -y   --no-install-recommends \
#             git \
#             cmake \
#             ninja-build \
#             gperf \
#             ccache \
#             dfu-util \
#             device-tree-compiler \
#             wget \
#             python3-pip \
#             python3-setuptools \
#             python3-tk \
#             python3-wheel \
#             xz-utils \
#             file \
#             make \
#             gcc \
#             gcc-multilib
# 
# ## (opt) tools for debugging and working
# RUN apt-get install -y   \
#             vim \
#             screen \
#             minicom \
#             libpython2.7
# 
# RUN locale-gen en_US.UTF-8
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US.UTF-8
# ENV LC_ALL en_US.UTF-8
# 


################################################################################
## build command automation
COPY env.sh /root/env.sh
COPY build.sh /root/build.sh

## automatic execution in command mode
CMD ["/bin/bash", "/root/build.sh"]
