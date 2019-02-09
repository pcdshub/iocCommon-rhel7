#!/bin/sh

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

# Figure out the hutch configuration: fee, amo, sxr, xpp, ...
IOC_HOST=`hostname -s`
cfg=`awk /$IOC_HOST/'{print $2;}'  $PYPS_ROOT/config/hosts.special`
if [ "${cfg}X" == "X" ]; then
    cfg=`echo $IOC_HOST | awk '{print substr($0,5,3);}' -`
fi
echo Using configuration $cfg.

if [ -z "$IOC" ]; then
	IOC=$IOC_HOST
fi

export SCRIPTROOT=$CONFIG_SITE_TOP/$cfg/iocmanager

# Setup our path, so we can find our python, procServ, and procmgrd!
source $IOC_COMMON/$T_A/common/iocManager_setup.cmd

# procServ should be SLAC version from pkg_mgr
export PROCSERV_EXE=$(which procServ)

# Inlined $SCRIPTROOT/initIOC.hutch
BASEPORT=39050
PROCMGRD_ROOT=procmgrd

PROCMGRD_LOG_DIR=$IOC_DATA/$IOC_HOST/logs

IOC_USER=${cfg}ioc
if [ "$cfg" == "xrt" ]; then
    IOC_USER=feeioc
fi
export IOC_USER

# Setup the iocData directories.
source $IOC_COMMON/$T_A/common/iocData_setup.cmd

# Find the procmgrd bin directory via ${cfg}_env PROCSERV_EXE variable
PROCMGRD_DIR=$(dirname $PROCSERV_EXE)

# TODO: Move procmgrd mkdir to common/iocData_setup.cmd
# Make sure we have a procmgrd log directory
if [ ! -d "$PROCMGRD_LOG_DIR" ]; then
	su $IOC_USER -s /bin/sh -c "mkdir -p  $PROCMGRD_LOG_DIR"
fi
su $IOC_USER -s /bin/sh -c "chmod g+rwx $PROCMGRD_LOG_DIR"

# Allow control connections from anywhere
# ignore ^D so procmgrd doesn't terminate on ^D
# No max on coresize
# Start child processes from /tmp
PROCMGRD_ARGS="--allow --ignore '^D' --coresize 0 -c /tmp"

# Disable readline and filename expansion
PROCMGRD_SHELL="/bin/sh --noediting -f"

launchProcMgrD()
{
	cfgduser=$1
    PROCMGRD_BIN=$PROCMGRD_DIR/$2
    ctrlport=$3
    logport=$(( ctrlport + 1 ))
	PROCMGRD_LOGFILE=$PROCMGRD_LOG_DIR/$2.log
    su ${cfgduser} -s /bin/sh -c "$PROCMGRD_BIN $PROCMGRD_ARGS -l $logport --logfile $PROCMGRD_LOGFILE $ctrlport $PROCMGRD_SHELL"
    python $SCRIPTROOT/fixTelnet.py $ctrlport
}

# Start up the procmgrd for the hutch IOC_USER.
launchProcMgrD $IOC_USER ${PROCMGRD_ROOT}0 $(( BASEPORT ))

# Start caRepeater.
CAREPEATER=$(which caRepeater)
if [ -e "$CAREPEATER" ]; then
	su ${IOC_USER} -s /bin/sh -c "${PROCSERV_EXE} --ignore ^D^C --logstamp --logfile $IOC_DATA/$IOC_HOST/iocInfo/caRepeater.log --name caRepeater 30000 $CAREPEATER"
	sleep 5
fi

# Start all of our processes.
python $SCRIPTROOT/startAll.py $cfg $IOC_HOST
