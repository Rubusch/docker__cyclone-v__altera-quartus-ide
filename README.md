# Container for my Cyclone V IDE: Altera Quartus

Contains a Dockerfile for creating a docker image of the **Quartus 16.1** build environment for my **DE1-SoC Board (rev D)** from Terrasic (University Program).

Building the image will install Quartus. Using a container from the image will start Quartus. Then ModelSim will be downloaded. ModelSim will be installed to _/opt/altera_ as well.

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

JTAG
(remember product id can be 6810 or 6010, see comments)
https://gladdy.github.io/2017/03/18/Altera-udev.html


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


## ModelSim

ModelSim first has to be configured in Quartus.

### Configure ModelSim in Quartus

In quartus, go **Tools** -> **Options** -> **EDA Tool Options** and provide a valid path to the ```_ase``` version's bin under **ModelSim Altera**: ```_/opt/altera/modelsim_ase/bin/_```

Then in an open project in Quartus, go **Assignments** -> **Settings** -> under **EDA Tool Settings** select **Simulation** (left side).



### Setting up ModelSim

The simulation page appears, fill out the following
 * **Tool name** : _ModelSim-Altera_
 * **Run gate-level simulation automatically after compilation** : _off_
 * under **EDA Netlist Writer Settings** -> **Format for output netlist** : _Verilog HDL_
 * **Map illegal HDL characters** : _off_
 * **Enable glitch filtering** : off
 * **Generate Value Change Dump (VCD) file script** : _off_
 * **NativeLink settings** : _None_

Click on **ok**


### Using ModelSim

In Quartus, go **Processing** -> **Start** -> **Start Analysis & Elaboration**. This will take some seconds.

After this was successfull, go **Tools** -> **Run Simulation Tool** -> **RTL Simulation**.


### Add Signals in ModelSim

In ModelSim, go to the **Library** window, open the **work** tree and rightclick the top level file of the project, and select **Create Wave**.

Delete signals: In the wave window by marking, and then hitting the del key.

Create signals: In the wave window rightclick the signal, e.g. clk, and select **Edit** -> **Create/Modify Waveform**: the create pattern wizzard appears!

Under patterns, select **Clock**

 * **Start Time**   : 0
 * **End Time**     : 5000
 * **Time Unit**    : ns

Click "Next"

 * "Clock Period** : 100
 * "Time Unit**    : ns
 * "Duty Cycle**   : 50

Click **Finish**




### Known Errors with ModelSim

 * "Can't launch ModelSim-Altera Simulation software -  make sure the software is properly installed and the environment variable LM_LICENSE_FILE or GGLS_LICENSE_FILE points to the correct license file."
   **FIX**: run in the shell
   ```
   $ /opt/altera/13.1/modelsim_ase/linuxaloem/vsimk
   ```
   Illegal instruction (TODO: what was this again??)
   ```
   $ /opt/altera/13.1/modelsim_ase/linuxaloem/vish
   ```

 * ```/opt/altera/13.1/modelsim_ase/linuxaloem/vish: error while loading shared
   libraries: libXft.so.2: cannot open shared object file: No such file or
   directory```
   **FIX**: install missing libraries as i386 version (btw. make sure that apt is able to handle :i386 packages, when installing into an 64bit system!)
   ```
   $ sudo aptitude install libxft2:i386
   $ sudo aptitude install libncurses5:i386
   ```
   TODO there was something with the iar.. libs package (x86 compatibility libraries)

TODO installation of Arbiter Testbench



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

* JTAG connection: the programmer needs a udev rule. Use intel documented udev rules ``/etc/udev/rules.d/92-usbblaster.rules``, and make sure ``/dev/bus/usb/<major>/<minor>`` has permissions **666**, or set it manually inside the container (needs to be started manually then FIXME). Get major and minor number with **lsusb**. Manually restart and reload udev: ``$ sudo udevadm control --reload-rules && sudo udevadm trigger``. **Don't unplug the board and replug it!**  
Optionally test the JTAG connection: ``$ /opt/altera/quartus/bin/jtagd --user-start --config ~/.jtagd.conf``, but probably this has no effect.

* If QSYS shows the error ``... Can't locate Getopt/Long.pm in @INC ...``, the following fix is documented:
```
$ sudo apt install libgetopt-simple-perl
$ cd altera/19.1/quartus/linux64/perl/bin
$ mv perl perl_old
$ ln -s /usr/bin/perl
```
