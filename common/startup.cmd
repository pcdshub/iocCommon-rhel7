#!/bin/sh
# ============================================
# Master startup script for linuxRT hosts
# This script is run as the BOOTFILE via
# pspxe:/u2/images/tftpboot/PXE/64_bit_RTLINUX/ipxe.ini
# ============================================
# linuxRT is an INTEL based target running
# embedded linux with PREEMPT_RT
# =============================================== 

# Pre-Startup
# ==================================================================
# Execute the initial script common to all IOCs
# This performs site nfsmounts and sets some environment variables
# used by all IOCs.
# This is also the script that creates the userid's.
# Must be done as the  "root" user.
/reg/d/iocCommon/linuxRT/common/linuxRT_nfs.cmd

# Linux Kernel Module load now invoked via linuxRT/`hostname`/startup.cmd

# Set EXTRA_LD_LIBS environment
export EXTRA_LD_LIBS=/reg/d/iocCommon/linuxRT/extralibs

# ===================================================================
# Start the world.
# Selects versions for desired kernel-modules, runs comon/kernel-modules.cmd,
# then launches the iocManager.
# ==================================================================
/reg/d/iocCommon/linuxRT/`hostname`/startup.cmd
