#!/bin/sh

# Set the target architecture
export T_A=linux-arm-apalis

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

# Figure out the hutch configuration: fee, amo, sxr, xpp, ...
cfg=`$IOC_COMMON/All/hostname_to_cfg.sh`
if [ ! -d $CONFIG_SITE_TOP/$cfg ]; then
	echo $cfg is not a valid configuration.
	echo Make sure your mpod crate hostname is listed in $CONFIG_SITE_TOP/hosts.byIP
	exit 1
fi
echo Using configuration $cfg.

#if [ -z "$IOC" ]; then
#	IOC=$IOC_HOST
#fi

# Setup our path, so we can find our python, procServ, and procmgrd!
#echo source iocManager_env.sh ...
#source $IOC_COMMON/All/iocManager_env.sh
#echo source ${cfg}_env.cmd ...
source $IOC_COMMON/All/${cfg}_env.sh

export SCRIPTROOT=$CONFIG_SITE_TOP/$cfg/iocmanager

# Inlined $SCRIPTROOT/initIOC.hutch
BASEPORT=39050
PROCMGRD_ROOT=procmgrd

IOC_HOST=`$IOC_COMMON/All/get_hostname.sh`
PROCMGRD_LOG_DIR=$IOC_DATA/$IOC_HOST/logs

IOC_USER=${cfg}ioc
if [ "$cfg" == "xrt" ]; then
    IOC_USER=feeioc
fi
export IOC_USER

# Setup the iocData directories.
echo Running iocData_setup.sh ...
source $IOC_COMMON/All/iocData_setup.sh

# TODO: Move procmgrd mkdir to common/iocData_setup.sh
# Make sure we have a procmgrd log directory
if [ ! -d $PROCMGRD_LOG_DIR ]; then
	su $IOC_USER -s /bin/sh -c "mkdir -p  $PROCMGRD_LOG_DIR"
fi
su $IOC_USER -s /bin/sh -c "chmod g+rwx $PROCMGRD_LOG_DIR"

# Allow control connections from anywhere
# ignore ^D so procmgrd doesn't terminate on ^D
# No max on coresize
# Start child processes from /tmp
PROCMGRD_ARGS="--allow --ignore '^D' --logstamp --coresize 0 -c /tmp"

#PROCSERV_SHELL="/bin/sh --noediting --init-file $IOC_COMMON/All/iocManager_env.sh -l"
PROCSERV_SHELL="/bin/sh --noediting --rcfile $IOC_COMMON/All/iocManager_env.sh -i"

# Disable procmgrd readline and filename expansion
PROCMGRD_SHELL="$PROCSERV_SHELL"

launchProcMgrD()
{
	echo Launching $2 ...
	cfgduser=$1
    PROCMGRD=$2
    ctrlport=$3
    logport=$(( ctrlport + 1 ))
	#echo PROCSERV_SHELL=$PROCSERV_SHELL
	#echo PROCMGRD=$PROCMGRD
	#echo which PROCMGRD=`which $PROCMGRD`
	PROCMGRD_LOGFILE=$PROCMGRD_LOG_DIR/$2.log
    echo su ${cfgduser} -c "$IOC_COMMON/All/runWithIocEnv.sh $PROCMGRD $PROCMGRD_ARGS -l $logport --logfile $PROCMGRD_LOGFILE $ctrlport $PROCMGRD_SHELL"
    su ${cfgduser} -c "$IOC_COMMON/All/runWithIocEnv.sh $PROCMGRD $PROCMGRD_ARGS -l $logport --logfile $PROCMGRD_LOGFILE $ctrlport $PROCMGRD_SHELL"
}

# Start up the procmgrd for the hutch IOC_USER.
launchProcMgrD $IOC_USER procmgrd0 $(( BASEPORT ))

# Start caRepeater.
CAREPEATER=`which caRepeater`
su ${IOC_USER} -l -c "procServ --logfile $IOC_DATA/$IOC_HOST/iocInfo/caRepeater.log --name caRepeater 30000 $CAREPEATER"
sleep 5

# Start all of our processes.
python $SCRIPTROOT/startAll.py $cfg $IOC_HOST
