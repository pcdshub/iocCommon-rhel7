#!/bin/sh
# =============================================================
# Master startup script for all PCDS linuxRT hosts
# This script is run as the BOOTFILE via
# pspxe:/u2/images/tftpboot/PXE/64_bit_RTLINUX/ipxe.ini
# Must be run as the "root" user.

# Set the target architecture
export T_A=linuxRT_glibc-x86_64

if [ -d /reg/d/iocCommon ]; then
	# =============================================================
	# Mount NFS drives for PCDS environment
	# =============================================================
	source /reg/d/iocCommon/linuxRT/common/linuxRT_nfs.cmd
else
	# =============================================================
	# Mount NFS drives for LCLS environment
	# =============================================================
	source /afs/slac/g/lcls/epics/iocCommon/All/Dev/linuxRT_nfs.sh
fi

# =============================================================
# Setup the common directory env variables
if [ -e /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
else
	source /afs/slac/g/pcds/config/common_dirs.sh
fi

# =================================================
# Install the PCDS linuxRT package
# Needed to support the IOCManager and a bash environment
# =================================================
export PSPKG_RELEASE=linuxRT-0.0.3
export EXTRA_LD_LIBS=$IOC_COMMON/linuxRT/extralibs
source $PSPKG_ROOT/etc/set_env.sh

# Install bash, expand, and a dummy xauth
export EXTRA_BIN=$IOC_COMMON/linuxRT/extrabins
if [ -d $EXTRA_BIN ]; then
	cp $EXTRA_BIN/bash /usr/bin
	cp $EXTRA_BIN/expand /usr/bin
	cp $EXTRA_BIN/xauth /usr/bin
fi
if [ -d $EXTRA_LD_LIBS ]; then
	# Make sure needed libs for bash are installed
	cp $EXTRA_LD_LIBS/libtinfo.so.5 /lib64
	#cp $EXTRA_LD_LIBS/libselinux.so.1 /lib64
fi

# =========================================
# Setup environment for users
# =========================================
if [ ! -e "/etc/profile.d" ]; then
	mkdir /etc/profile.d
fi
cp $IOC_COMMON/linuxRT/facility/ioc_env.sh /etc/profile.d/
cp $IOC_COMMON/linuxRT/facility/linuxRT_env.sh /etc/profile.d/
chmod 0777 /etc/profile.d/ioc_env.sh 
chmod 0777 /etc/profile.d/linuxRT_env.sh 

# =============================================================
# Create PCDS user id's
# =============================================================
source $IOC_COMMON/linuxRT/common/linuxRT_users.cmd

# Turn on CORE Dumps, memory locking, and real time scheduling
sysctl -w kernel.core_pattern=/tmp/%p.core
ulimit -c unlimited
ulimit -l unlimited
ulimit -r unlimited

# =============================================================
# Run host specific startup if supplied
# Allows host specific selection of versions for kernel-modules
# =============================================================
if [ -f $IOC_COMMON/linuxRT/`hostname`/startup.cmd ];
then
	source $IOC_COMMON/linuxRT/`hostname`/startup.cmd
fi

# =============================================================
# Load Kernel Modules 
# =============================================================
source $IOC_COMMON/linuxRT/common/kernel-modules.cmd

# Some older versions of iocManager use PYPS_ROOT instead of PYPS_SITE_TOP
PYPS_ROOT=$PYPS_SITE_TOP

# Launch the iocManager
$PYPS_SITE_TOP/apps/ioc/latest/initIOC

