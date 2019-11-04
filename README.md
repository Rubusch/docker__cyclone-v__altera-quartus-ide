# docker__de1-soc-fpga-board

Contains a Dockerfile for building the build environment for my DE1-SoC Board (rev D) from Terrasic / University Edition.

The image will install Intel's Quartus Prime (former Altera's Quartus II - changed name when Intel bought Altera).



## Resources

Terrasic Material
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836&PartNo=4


Getting started with the DE1-SoC video serie
https://www.youtube.com/playlist?list=PLKcjQ_UFkrd7UcOVMm39A6VdMbWWq-e_c



## Build

```
$ cd ./docker/
$ time docker build --no-cache -t rubuschl/de1-soc-board:$(date +%Y%m%d%H%M%S) .
$ docker run --rm -ti -v /sys:/sys:ro -v $PWD/output:/build rubuschl/de1-soc-board:20191104161353 /bin/bash
```


In order to make things easier, provide pre-downloaded Quartus images on a local webserver, then build the docker container as follows.

```
$ docker build --build-arg MIRROR=http://localhost/quartus -t rubuschl/de1-soc-board:$(date +%Y%m%d%H%M%S) .
```


TODO: use ```-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix ``` for the xserver
TODO: ```--privileged``` mode for accessing hw devices?

## Target

TODO working with the target for the DE1-SoC usually means to flash an SD card.
