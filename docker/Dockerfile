FROM ubuntu:xenial
MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge
RUN apt-get install -y \
        apt-utils

################################################################################
## RESOURCES
##
## Jamie Iles <jamie@jamieiles.com>
## https://www.jamieiles.com/posts/quartus-docker/
##
## Quartus II was renamed to Quartus Prime (short before Intel bought Altera)

## Quartus 16.1 - freely available on the net (in 2019)
## (comment the following out or adjust it for manually loading a quartus tarball)
ARG QUARTUS=QuartusLiteSetup-16.1.0.196-linux.run
ARG MIRROR161=http://download.altera.com/akdlm/software/acdsinst/16.1/196/ib_installers/
ARG DEVICE_FILES="cyclonev-16.1.0.196.qdz cyclone-16.1.0.196.qdz"
###

## model sim
ARG MODELSIM=ModelSimSetup-16.0.0.211-linux.run
ARG MIRROR160=http://download.altera.com/akdlm/software/acdsinst/16.0/211/ib_installers/

## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""

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
        xvfb \
        build-essential \
        libpng-dev \
        libxtst6:i386 \
        libc6-dev-i386 \
        libxft2 \
        lib32z1 \
        lib32ncurses5 \
        libbz2-1.0

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## avoid blank qt windows
ENV QT_X11_NO_MITSHM 1

## (opt) tools for debugging and working,
## X11-apps - for testing the xserver via xclock
## firefox-esr - quartus needs this for some dialogs (...)
RUN apt-get install -y   \
            vim \
            screen \
            minicom \
            sudo \
            x11-apps \
            firefox

# NOTE: Jamie Iles mentions to remove the following files in order to avoid sporadic instabilities
# RUN rm -rf /opt/altera/quartus/linux64/libccl_curl_drl.so
# RUN rm -rf /opt/altera/quartus/linux64/libcrypto.so.1.0.0
# RUN rm -rf /opt/altera/quartus/linux64/libcurl.so.4
# RUN rm -rf /opt/altera/quartus/linux64/libssl.so.1.0.0




################################################################################
## Either copy a manually downloaded copy of Quartus onto the container
#RUN wget http://localhost/quartus/$QUARTUS.tar
#RUN cd /opt && tar xf /root/$QUARTUS.tar && rm /root/$QUARTUS.tar
#RUN cd /opt/components && for DEV_FILE in $DEVICE_FILES; do wget $MIRROR$DEV_FILE; done
##
## NOTE:
## docker COPY typically fails, due to not enough temporary space available. Downloading
## it via localhost then is one alternative.

## setup user and run stuff under user
RUN useradd "$USER" -m --password "$USER"
RUN usermod -a -G sudo "$USER"
RUN usermod -a -G dialout "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers

## install quartus 16.1 from the internet
RUN cd /opt && wget $MIRROR161$QUARTUS
RUN cd /opt && for DEV_FILE in $DEVICE_FILES; do wget $MIRROR161$DEV_FILE; done
RUN cd /opt && chmod +x $QUARTUS
RUN cd /opt && ./$QUARTUS --mode unattended --unattendedmodeui minimal --installdir /opt/altera

## fix: firefox - libstdc++.so.6: version `CXXABI_1.3.8' not found
RUN mv /opt/altera/quartus/linux64/libstdc++.so.6{,.orig}
RUN ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/altera/quartus/linux64/

## fix: setup udev rule for 'USB2 BLASTER' (separate JTagger), read/write permissions for user
#RUN echo 'BUS=="usb", SYSFS{idVendor}=="09fb", SYSFS{idProduct}=="6010", MODE="0666"' > /etc/udev/rules.d/52-usbblaster.rules
#RUN echo 'BUS=="usb", SYSFS{idVendor}=="09fb", SYSFS{idProduct}=="6810", MODE="0666"' >> /etc/udev/rules.d/52-usbblaster.rules

## install modelsim 16.0 from the internet
RUN cd /opt && wget $MIRROR160$MODELSIM
RUN cd /opt && chmod +x $MODELSIM
RUN cd /opt && ./$MODELSIM --mode unattended --unattendedmodeui minimal --installdir /opt/altera

RUN cd /opt && rm /opt/*.run /opt/altera/uninstall -rf
RUN chown "$USER.$USER" -R /opt

################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
