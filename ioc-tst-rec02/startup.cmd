#!/bin/sh

# ===============================================================
# Define kernel module driver locations
# ===============================================================
#
# TODO: Create version specific kernel module releases under /reg/g/pcds/package
#

# Optional: Enable kernel debugging
sysctl -w kernel.core_pattern=/tmp/%p.core
ulimit -c unlimited

