export QT_X11_NO_MITSHM=1
export LD_LIBRARY_PATH=/usr/lib/gcc/i686-linux-gnu/6.0.0:$LD_LIBRARY_PATH

## setup for quartus (15.1) on linux
## resource:
## from http://www.armadeus.org/wiki/index.php?title=Quartus_installation_on_Linux
##
## quartus is in '/opt/altera/quartus/bin'
export ALTERAPATH="/opt/altera/"
export ALTERAOCLSDKROOT="${ALTERAPATH}/hls"
export QUARTUS_ROOTDIR="${ALTERAPATH}/quartus"
export QUARTUS_ROOTDIR_OVERRIDE="$QUARTUS_ROOTDIR"
export QSYS_ROOTDIR="${ALTERAPATH}/quartus/sopc_builder/bin"
export PATH="$PATH:${ALTERAPATH}/quartus/bin"
export PATH="$PATH:${ALTERAPATH}/nios2eds/bin"
export PATH="$PATH:${QSYS_ROOTDIR}"
