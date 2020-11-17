#!/bin/sh
# =============================================================
# Master startup script for all PCDS rhel5 IOC hosts
# This script is run as the BOOTFILE via
# /etc/rc.d/init.d/ioc
# Must be run as the "root" user.

# Set the target architecture
export T_A=linux-arm-apalis
export IOC_COMMON=/reg/d/iocCommon

if [ ! -d /reg/g/pcds/epics ]; then
# TODO: Move to slac-mount-nfs.service
if [ -f $IOC_COMMON/$T_A/common/mount_nfs.cmd ]; then
	# =============================================================
	# Mount common NFS drives
	# =============================================================
	source $IOC_COMMON/$T_A/common/mount_nfs.cmd
elif [ -f /afs/slac/g/lcls/epics/iocCommon/$T_A/common/mount_nfs.cmd ]; then
	# =============================================================
	# Mount NFS drives for LCLS environment
	# =============================================================
	source /afs/slac/g/lcls/epics/iocCommon/$T_A/common/mount_nfs.cmd 
fi
fi

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

# =============================================================
# Create user id's
# Must be done manually for linux-arm-apalis so passwords can be set.
# Only needs to be done once, but filesystem needs to be mounted
# rw so the user id's can be added and saved.
# =============================================================
# source $IOC_COMMON/$T_A/common/add_users.cmd

# Turn on CORE Dumps, memory locking, and real time scheduling
sysctl -w kernel.core_pattern=/tmp/%p.core
ulimit -c unlimited
ulimit -l unlimited
ulimit -r unlimited

# Get hostname using $IOC_COMMON/All/get_hostname.sh
# Checks for hostnames in $CONFIG_SITE_TOP/hosts.byIP
IOC_HOST=`$IOC_COMMON/All/get_hostname.sh | tail -1`
if [ "`hostname -s`" != "$IOC_HOST" ]; then
	# Update hostname to match one found in $CONFIG_SITE_TOP/hosts.byIP
	echo Updating hostname from `hostname -s` to $IOC_HOST
	hostname $IOC_HOST
fi

# Stop isegioc
systemctl stop isegioc

# =============================================================
# Run host specific startup if supplied
# Allows host specific selection of versions for kernel-modules
# =============================================================
if [ -f $IOC_COMMON/$T_A/$IOC_HOST/startup.cmd ];
then
	source $IOC_COMMON/$T_A/$IOC_HOST/startup.cmd
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

