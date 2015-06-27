#!/bin/sh
# =============================================================
# Master startup script for all PCDS linuxRT hosts
# This script is run as the BOOTFILE via
# pspxe:/u2/images/tftpboot/PXE/64_bit_RTLINUX/ipxe.ini
# Must be run as the "root" user.
# =============================================================
# linuxRT is an INTEL based target running
# embedded linux with PREEMPT_RT kernel
# =============================================================

# =============================================================
# Mount NFS drives for PCDS environment
/reg/d/iocCommon/linuxRT/common/linuxRT_nfs.cmd

# =============================================================
# Create PCDS user id's
# =============================================================
/reg/d/iocCommon/linuxRT/common/linuxRT_users.cmd

# =============================================================
# Run host specific startup if supplied
# Allows host specific selection of versions for kernel-modules
# =============================================================
if [ -f /reg/d/iocCommon/linuxRT/`hostname`/startup.cmd ];
then
	source /reg/d/iocCommon/linuxRT/`hostname`/startup.cmd
fi

# =============================================================
# Load Kernel Modules 
# =============================================================
source /reg/d/iocCommon/linuxRT/common/kernel-modules.cmd

# Launch the iocManager
/reg/g/pcds/pyps/apps/ioc/latest/initIOC
