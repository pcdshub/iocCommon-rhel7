#!/bin/sh
# =============================================================
# Master startup script for all PCDS rhel5 IOC hosts
# This script is run as the BOOTFILE via
# /etc/rc.d/init.d/ioc
# Must be run as the "root" user.

# Set the target architecture
export T_A=apalis

# =============================================================
# Setup the common directory env variables
# Set the common directory env variables
if   [ -f  /usr/local/lcls/epics/config/common_dirs.sh ]; then
	source /usr/local/lcls/epics/config/common_dirs.sh 
elif [ -f  /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -f  /afs/slac/g/lcls/epics/config/common_dirs.sh ]; then
	source /afs/slac/g/lcls/epics/config/common_dirs.sh
fi

if [ -f $IOC_COMMON/$T_A/common/mount_nfs.cmd ]; then
	# =============================================================
	# Mount common NFS drives
	# =============================================================
	source $IOC_COMMON/$T_A/common/mount_nfs.cmd
elif [ -f /afs/slac/g/lcls/epics/iocCommon/apalis/common/mount_nfs.cmd ]; then
	# =============================================================
	# Mount NFS drives for LCLS environment
	# =============================================================
	source /afs/slac/g/lcls/epics/iocCommon/apalis/common/mount_nfs.cmd 
fi

# =============================================================
# Create user id's
# Must be done manually for apalis so passwords can be set.
# Only needs to be done once, but filesystem needs to be mounted
# rw so the user id's can be added and saved.
# =============================================================
# source $IOC_COMMON/$T_A/common/add_users.cmd

# Turn on CORE Dumps, memory locking, and real time scheduling
sysctl -w kernel.core_pattern=/tmp/%p.core
ulimit -c unlimited
ulimit -l unlimited
ulimit -r unlimited

# =============================================================
# Run host specific startup if supplied
# Allows host specific selection of versions for kernel-modules
# =============================================================
if [ -f $IOC_COMMON/$T_A/`hostname`/startup.cmd ];
then
	source $IOC_COMMON/$T_A/`hostname`/startup.cmd
fi

# =============================================================
# Load Kernel Modules 
# =============================================================
if [ -f $IOC_COMMON/$T_A/common/kernel-modules.cmd ];
then
	source $IOC_COMMON/$T_A/common/kernel-modules.cmd
fi

# Launch the iocManager
source $IOC_COMMON/$T_A/common/initIOC.cmd

