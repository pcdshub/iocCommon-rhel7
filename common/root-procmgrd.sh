#!/bin/sh
# Run as root once system is booted and NFS mounts are completed.

# Set the common directory env variables
if   [ -f  /usr/local/lcls/epics/config/common_dirs.sh ]; then
	source /usr/local/lcls/epics/config/common_dirs.sh 
elif [ -f  /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -f  /afs/slac/g/lcls/epics/config/common_dirs.sh ]; then
	source /afs/slac/g/lcls/epics/config/common_dirs.sh
fi

# Figure out the hutch configuration: fee, amo, sxr, xpp, ...
cfg=`$IOC_COMMON/All/hostname_to_cfg.sh`
if [ ! -d $CONFIG_SITE_TOP/$cfg ]; then
	echo $cfg is not a valid configuration.
	echo Make sure your mpod crate hostname is listed in $CONFIG_SITE_TOP/hosts.byIP
	exit 1
fi
echo Using configuration $cfg.
#source $IOC_COMMON/All/${cfg}_env.sh

IOC_USER=${cfg}ioc
if [ "$cfg" == "xrt" ]; then
    IOC_USER=feeioc
fi

# Run procmgrd.sh as IOC_USER
su $IOC_USER -s /bin/sh -c "$IOC_COMMON/All/procmgrd.sh"
