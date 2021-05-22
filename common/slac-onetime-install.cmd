#!/bin/bash
# Run as root from linux-arm-apalis host

# Remount / writeable
mount -o remount,rw /

# Mount IOC_COMMON
export IOC_COMMON=/reg/d/iocCommon
mkdir -p $IOC_COMMON
if [ ! -d $IOC_COMMON/All ]; then
	mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.73:/nfsexport/datapool/iocCommon $IOC_COMMON
fi

# Mount other SLAC NFS drives
source $IOC_COMMON/linux-arm-apalis/common/mount_nfs.cmd

# Disable isegioc
systemctl stop    isegioc.service
systemctl disable isegioc.service

# Validate the hostname
IOC_HOST=`$IOC_COMMON/All/get_hostname.sh`
if [ -z "$IOC_HOST" ]; then
	echo $HOSTNAME is not a valid hostname.
	echo Make sure your mpod crate hostname is listed in $CONFIG_SITE_TOP/hosts.byIP
	exit 1
fi
# Figure out the hutch configuration: fee, amo, sxr, xpp, ...
export CONFIG_SITE_TOP=/reg/g/pcds/pyps/config
cfg=`$IOC_COMMON/All/hostname_to_cfg.sh`
if [ ! -d $CONFIG_SITE_TOP/$cfg ]; then
	echo $cfg is not a valid configuration.
	echo Make sure your mpod crate hostname is listed in $CONFIG_SITE_TOP/hosts.byIP
	exit 1
fi
echo Using configuration $cfg.

# Install startup scripts
T_A=linux-arm-apalis
SLAC_STARTUP=/mnt/user/data/config/slac-startup.cmd
cp /reg/d/iocCommon/$T_A/common/slac-mount-iocCommon.service /lib/systemd/system
cp /reg/d/iocCommon/$T_A/common/slac-mount-nfs.service /lib/systemd/system
cp /reg/d/iocCommon/$T_A/common/slac-startup.service /lib/systemd/system
cp /reg/d/iocCommon/$T_A/common/slac-procmgrd.service /lib/systemd/system

# Fix hutch userid
cp /lib/systemd/system/slac-procmgrd.service  /tmp/slac-procmgrd.service
cat /tmp/slac-procmgrd.service | sed -e "s/tstioc/${cfg}ioc/" > /lib/systemd/system/slac-procmgrd.service 

# Enable our services
systemctl enable slac-mount-iocCommon
systemctl enable slac-mount-nfs
systemctl enable slac-startup
systemctl enable slac-procmgrd

# Create the mount directories while file-system is mount-rw
mkdir -p /reg/d/iocData
mkdir -p /reg/neh/home
mkdir -p /reg/g/pcds
mkdir -p /reg/common/package
#mkdir -p /reg/neh/home5/bhill

# Setup default profile scripts for users
if [ -f $IOC_COMMON/$T_A/facility/ioc_env.sh ]; then
	# =========================================
	# Setup environment for ioc users
	# =========================================
	if [ ! -e "/etc/profile.d" ]; then
		mkdir /etc/profile.d
	fi
	cp $IOC_COMMON/$T_A/facility/ioc_env.sh     /etc/profile.d/
	chmod 0777 /etc/profile.d/ioc_env.sh 
fi

# Add users
/reg/d/iocCommon/$T_A/common/add_users.cmd

# Make sure isegioc service is disabled
systemctl disable isegioc.service

# Mount RO
#mount -o remount,ro /

