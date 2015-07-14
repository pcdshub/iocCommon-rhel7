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

# Optional: Enable kernel debugging
sysctl -w kernel.core_pattern=/tmp/%p.core
ulimit -c unlimited

