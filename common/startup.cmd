#!/bin/sh
# =============================================================
# Master startup script for all PCDS rhel7 IOC hosts
# This script is run as the BOOTFILE via
# /etc/rc.d/init.d/ioc
# Must be run as the "root" user.

# Set the target architecture
export T_A=rhel7-x86_64

# =============================================================
# Setup the common directory env variables
if [ -f /reg/g/pcds/pyps/config/common_dirs.sh ]; then
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
	cp $IOC_COMMON/$T_A/facility/ioc_env.sh /etc/profile.d/
	chmod 0777 /etc/profile.d/ioc_env.sh 
fi

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

