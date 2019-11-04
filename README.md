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
$ time docker build --no-cache -t rubuschl/de1-soc-board:$(date +%Y%m%d%H%M%S) .
$ time docker run -ti --rm -v $PWD/output:/mnt rubuschl/de1-soc-board:20191102182643
```


In order to make things easier, provide pre-downloaded Quartus images on a local webserver, then build the docker container as follows.

```
$ cd ./docker/
$ docker build --build-arg MIRROR=http://localhost/quartus -t rubuschl/de1-soc-board:$(date +%Y%m%d%H%M%S) .
$ time docker run -ti --rm -v $PWD/output:/mnt rubuschl/de1-soc-board:20191102182643
```


## Debug

**NOTE**: privileged mode is not _safe_, this docker container is supposed rather to allow for archiving of the toolchain


```
$ docker run -ti --privileged -v $PWD/output:/mnt rubuschl/de1-soc-board:20191102182643 /bin/bash
docker $>
```


## Target

TODO working with the target for the DE1-SoC usually means to flash an SD card.
