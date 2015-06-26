#!/bin/sh

# ===============================================================
# Define kernel module driver locations
# ===============================================================
#
# TODO: Create version specific kernel module releases under /reg/g/pcds/package
#
KERNEL_DRIVER_HOME=/home1/mdewart/workspace/linuxKernel_Modules
LINUX_RT=buildroot-glibc-x86_64

export PERLE_SERIAL_DRIVER=$KERNEL_DRIVER_HOME/perle-serial/$LINUX_RT
export MEGARAID_DRIVER=$KERNEL_DRIVER_HOME/megaRAID/$LINUX_RT
export EDT_DRIVER=$KERNEL_DRIVER_HOME/edt/$LINUX_RT/EDTpdv
#export EVENT2_DRIVER=$KERNEL_DRIVER_HOME/event2/$LINUX_RT

# Optional: Enable kernel debugging
sysctl -w kernel.core_pattern=/tmp/%p.core
ulimit -c unlimited


# ===================================================================
# Load linux Kernel Modules 
# ==================================================================
# Must be done as "root" user.
/reg/d/iocCommon/linuxRT/common/kernel-modules.cmd

# Launch the iocManager
/reg/g/pcds/pyps/apps/ioc/latest/initIOC
