#!/bin/bash
# Run as root from linux-arm-apalis host

# Remount / writeable
mount -o remount,rw /

# Mount IOC_COMMON
export IOC_COMMON=/reg/d/iocCommon
mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.76:/nfsexport/datapool/iocCommon $IOC_COMMON

# Disable isegioc
systemctl disable isegioc.service

# Install startup scripts
T_A=linux-arm-apalis
SLAC_STARTUP=/mnt/user/data/config/slac-startup.cmd
cp /reg/d/iocCommon/$T_A/common/slac-mount-iocCommon.service /lib/systemd/system
cp /reg/d/iocCommon/$T_A/common/slac-startup.service /lib/systemd/system
cp /reg/d/iocCommon/$T_A/common/slac-procmgrd.service /lib/systemd/system
systemctl enable slac-mount-iocCommon
systemctl enable slac-startup
systemctl enable slac-procmgrd

# Add users
/reg/d/iocCommon/$T_A/common/add_users.cmd

