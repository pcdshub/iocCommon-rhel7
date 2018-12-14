#!/bin/sh
# =============================================================
# Master startup script for all PCDS rhel5 IOC hosts
# This script is run as the BOOTFILE via
# /etc/rc.d/init.d/ioc
# Must be run as the "root" user.

# Set the target architecture
export T_A=apalis

if [ -d /reg/d/iocCommon ]; then
	# =============================================================
	# Mount NFS drives for PCDS environment
	# =============================================================
	source /reg/d/iocCommon/$T_A/common/mount_nfs.cmd
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

if [ -f $IOC_COMMON/$T_A/facility/ioc_env.sh ]; then
	# =========================================
	# Setup environment for ioc users
	# =========================================
	if [ ! -e "/etc/profile.d" ]; then
		mkdir /etc/profile.d
	fi
	cp $IOC_COMMON/$T_A/facility/ioc_env.sh     /etc/profile.d/
	cp $IOC_COMMON/$T_A/facility/linuxRT_env.sh /etc/profile.d/
	chmod 0777 /etc/profile.d/ioc_env.sh 
	chmod 0777 /etc/profile.d/linuxRT_env.sh 
fi

# =============================================================
# Create PCDS user id's
# =============================================================
source $IOC_COMMON/$T_A/common/add_users.cmd

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
source $IOC_COMMON/$T_A/common/kernel-modules.cmd

# Some older versions of iocManager use PYPS_ROOT instead of PYPS_SITE_TOP
PYPS_ROOT=$PYPS_SITE_TOP

# Launch the iocManager
$PYPS_SITE_TOP/apps/ioc/latest/initIOC

