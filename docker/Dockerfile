FROM ubuntu:bionic
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>

## RESOURCES
##
## Jamie Iles <jamie@jamieiles.com>
## https://www.jamieiles.com/posts/quartus-docker/
##
## Matt Ownby
## http://my-cool-projects.blogspot.com/2018/10/how-to-dockerize-intel-quartus-1801.html
##
## Quartus II was renamed to Quartus Prime (after Intel bought Altera)


WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

ARG QUARTUS="Quartus-pro-16.1.0.196-linux-complete"

# ARG MIRROR=http://download.altera.com/akdlm/software/acdsinst/16.1/196/ib_installers/
# ARG QUARTUS=QuartusLiteSetup-16.1.0.196-linux.run
# ARG QUARTUS_UPDATE=QuartusSetup-16.1.2.203-linux.run
# ARG DEVICE_FILES="cyclonev-16.1.0.196.qdz cyclone-16.1.0.196.qdz"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install --no-install-recommends -y \
        ca-certificates \
        lib32ncurses5-dev \
        libc6:i386 \
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


# RUN cd /tmp && wget $MIRROR$QUARTUS && \
#         for DEV_FILE in $DEVICE_FILES; do wget $MIRROR$DEV_FILE; done && \
#         chmod +x $QUARTUS && \
#         ./$QUARTUS --mode unattended --installdir /opt/altera/ && \
#         rm /tmp/* /opt/altera/uninstall -rf

# these files conflict with the Ubuntu versions and cause random segfaults
# RUN rm /opt/altera/quartus/linux64/libccl_curl_drl.so \
#         /opt/altera/quartus/linux64/libcrypto.so.1.0.0 \
#         /opt/altera/quartus/linux64/libcurl.so.4 \
#         /opt/altera/quartus/linux64/libssl.so.1.0.0


## (opt) tools for debugging and working
RUN apt-get install -y   \
            vim \
            screen \
            minicom


################################################################################
## copy my personal copy of Quartus onto the container
COPY $QUARTUS.tar /root/$QUARTUS.tar
RUN cd /opt && tar xf /root/$QUARTUS.tar


################################################################################
## build command automation
COPY env.sh /root/env.sh
COPY build.sh /root/build.sh

## automatic execution in command mode
CMD ["/bin/bash", "/root/build.sh"]
