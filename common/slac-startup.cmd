#!/bin/bash
# Run as root during bootup after network and NFS are initialized

export T_A=linux-arm-apalis
export IOC_COMMON=/reg/d/iocCommon

# Mount SLAC pcds iocCommon
mkdir -p $IOC_COMMON
if [ ! -d $IOC_COMMON/$T_A ]; then
#    mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.76:/nfsexport/datapool/iocCommon $IOC_COMMON
    mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.73:/nfsexport/datapool/iocCommon $IOC_COMMON
fi

# Run SLAC startup script
if [  -f   $IOC_COMMON/$T_A/common/startup.cmd ]; then
    source $IOC_COMMON/$T_A/common/startup.cmd 
fi

#while((1)); do
#	sleep 10
#done
