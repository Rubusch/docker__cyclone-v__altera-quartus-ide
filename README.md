# Docker - Altera Cyclone V IDE: Altera Quartus

Contains a Dockerfile for creating a docker image of the **Quartus 16.1** build environment for my **DE1-SoC Board (rev D)** from Terrasic (University Program).

Building the image will install Quartus. Using a container from the image will start Quartus.

The **workspace** folder will be mounted as /home/user inside the docker. It will serve as workspace and may kept under git outside the docker container.



## Resources

Terrasic Material
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836&PartNo=4


Getting started with the DE1-SoC video serie
https://www.youtube.com/playlist?list=PLKcjQ_UFkrd7UcOVMm39A6VdMbWWq-e_c


Cornell University Material on the DE1-SoC Board (links)
https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/index.html



## Build

Installation uses last release freely available on the net (in 2019)

```
$ cd docker
$ time docker build --build-arg USER=$USER -t rubuschl/cyclone-v-ide:$(date +%Y%m%d%H%M%S) .
```


## Usage

Find the correct tag as follows. Here we take _20191104161353_ as an example tag.

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/cyclone-v-ide   20191104161353      cbf4cb380168        24 minutes ago      15.5GB
    ubuntu                   xenial              5f2bf26e3524        4 days ago          123MB

$ xhost +"local:docker@"

$ docker run --rm -ti --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys:/sys:ro -v $PWD/workspace:/home/user --user=$USER:$USER --workdir=/home/$USER rubuschl/cyclone-v-ide:20191104161353
```


## Debug

For debugging the container login to the docker container

```
$ docker images
    REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/cyclone-v-ide   20191104161353      cbf4cb380168        24 minutes ago      15.5GB
    ubuntu                   xenial              5f2bf26e3524        4 days ago          123MB

$ xhost +"local:docker@"

$ docker run --rm -ti -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /sys:/sys:ro -v $PWD/workspace:/home/$USER --user=$USER:$USER --workdir=/home/$USER rubuschl/cyclone-v-ide:20191104161353 /bin/bash
```

In the container start quartus as follows
```
docker$ /opt/altera/quartus/bin/quartus
```



## Issues

* Working with the target for the DE1-SoC usually means to flash an SD card. The .sof files also can be converted into .rbf files and as such loaded dynamically via Linux on the board to the FPGA fabric. Further for the DE1-SoC you may use a tftp boot and nfs setup as automation solution.

* For hardware access run the docker container with ```--privileged``` mode

* If Quartus only shows empty windows set ```export QT_X11_NO_MITSHM=1```, or source _```~/env.sh```

* Alternative installation (more recent versions) - Download a version of _Quartus_ **manually** from Intel which fits the size and needs. NB: Quartus Pro 16.x is around 15GB. In your configured webserver's _DirectoryRoot_ (test with localhost), create another directory _"quartus"_. Move the Quartus tarball into this directory. Pass the exact name of that tarball as build argument to the docker build instruction. And reimplement the Dockerfile, instead of downloading, to use the tarball (this is rather the idea, since more recent Quartus will imply a more recent base system, means different set of libs to be installed, etc, etc.). Remember to use ```--network host``` for accessing the localhost.

```
$ sudo mkdir /var/www/html/quartus
$ sudo mv <the downloaded quartus> /var/www/html/quartus/

$ cd docker
$ time docker build --build-arg QUARTUS="Quartus-pro-16.1.0.196-linux-complete" -t rubuschl/cyclone-v-ide:$(date +%Y%m%d%H%M%S) .
```

* "No space left" at building the image, can be a docker issue, in case set the minimum image size up to e.g. 50GB:
```
$ sudo systemctl stop containerd
$ sudo systemctl stop docker
$ sudo vi /etc/docker/daemon.json
    {
      "storage-driver": "devicemapper",
      "storage-opts": [
            "dm.basesize=50G"
      ]
    }
$ sudo systemctl start containerd
$ sudo systemctl start docker
```
