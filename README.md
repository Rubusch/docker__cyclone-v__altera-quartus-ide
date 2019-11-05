# docker__de1-soc-fpga-board

Contains a Dockerfile for building the build environment for my DE1-SoC Board (rev D) from Terrasic / University Edition.

The image will install Intel's Quartus Prime (former Altera's Quartus II - changed name when Intel bought Altera).



## Resources

Terrasic Material
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836&PartNo=4


Getting started with the DE1-SoC video serie
https://www.youtube.com/playlist?list=PLKcjQ_UFkrd7UcOVMm39A6VdMbWWq-e_c


Cornell University Material on the DE1-SoC Board (links)
https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/index.html



## Build

Either try installing over the net

```
$ cd docker
$ time docker build -t rubuschl/de1-soc-board:$(date +%Y%m%d%H%M%S) .
```


Or: Download a version of **Quartus** manually from Intel which fits the size and needs. E.g. Quartus Pro 16.x is around 15GB.

In your configured webserver (test with localhost), create another directory _quartus_. Move the Quartus tarball into this directory.

Pass the exact name of the tarball as build argument to the docker build instruction.

```
$ sudo mkdir /var/www/html/quartus
$ sudo mv <the downloaded quartus> /var/www/html/quartus/

$ cd docker
$ time docker build --build-arg QUARTUS="Quartus-pro-16.1.0.196-linux-complete" -t rubuschl/de1-soc-board:$(date +%Y%m%d%H%M%S) .
```


## Usage

Prepare the host system, make the x server accessible

```
$ xhost +"local:docker@"
```


Login to the docker container

```
$ docker run --rm -ti --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys:/sys:ro -v $PWD/output:/build rubuschl/de1-soc-board:20191104161353 /bin/bash

docker$ /opt/altera/quartus/bin/quartus
```


## Issues

 * Working with the target for the DE1-SoC usually means to flash an SD card.
 * For hardware access run the docker container with ```--privileged``` mode
 * If Quartus only shows empty windows set ```export QT_X11_NO_MITSHM=1```, or put this into _```~/.profile```
