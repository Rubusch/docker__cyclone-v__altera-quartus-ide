# Container for my Cyclone V IDE: Altera Quartus

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


Download links for Quartus Editions (direct links, no Intel registration)
https://github.com/CTSRD-CHERI/quartus-install/blob/master/quartus-install.py



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

* Working with the target for the DE1-SoC usually means to flash an SD card. The .sof files can be converted into .rbf files which then can also be loaded dynamically at runtime under the installed  Linux board support package (BSP) to the FPGA fabric. Further, for the DE1-SoC you may use a tftp boot and nfs setup as automation solution. As a hint, the Cyclone V SoC had quite some community support by EBV's Socrates Board users, thus the configuration for the altera/Socrates board also should run well for the terrasic/DE1-SoC board.

* For hardware access, e.g. using Qsys, run the docker container with ```--privileged``` mode

* Quartus may fall into a state to only shows empty, blank windows. Set ```export QT_X11_NO_MITSHM=1```, or source _```~/env.sh```.

* Quartus installation process is known to hang in the end. The fix I found is to install it with the ui _minimal_. In cases where this does not help, the install process may be stopped after some minits of inactivity, then restarted (in case needs to be implemented then in the docker file). Where a second execution of the build Quartus usually should run smoothly.

* Quartus 16.1 nowadays (2019) is a bit old. It is still relatively small, though, having around 15GB compared to Quartus 19.x with around 55GB. Alternatively install a more recent version: Download a version of _Quartus_ **manually** from Intel and best might be to import it via webserver i.e. localhost and e.g. configured apache. Easiest then is to use your already configured webserver's _DirectoryRoot_ i.e. _/var/www/html_ on debian (test with localhost). There create another directory named _"quartus"_. Move the Quartus tarball into this directory. Pass the exact name of that tarball as build argument to the docker build instruction. And adjust the Dockerfile: instead of downloading from internet, now use the tarball (this is rather an idea, since more recent Quartus also implies a more recent base system, means different set of libs to be installed, etc, etc. - I haven't really tested this). Remember to use ```--network host``` for accessing the localhost!

```
$ sudo mkdir /var/www/html/quartus
$ sudo mv <the downloaded quartus> /var/www/html/quartus/

$ cd docker
$ time docker build --build-arg QUARTUS="Quartus-pro-16.1.0.196-linux-complete" -t rubuschl/cyclone-v-ide:$(date +%Y%m%d%H%M%S) .
```

* The "No space left" issue at building the image, can be a docker issue, in case set the minimum image size up to e.g. 50GB:
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

* The "permission denied" may happen if you forget either to set the _-w_ directive, or the _-u_ directive, or both at the _docker run_ command, it then falls back to root and/or /root - best is to simply copy&paste the commands here.
