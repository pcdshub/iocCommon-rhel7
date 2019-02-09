#!/bin/sh
# Source from apalis OS to use our procServ and python 

source $SETUP_SITE_TOP/pathmunge.sh

CROSS_ARCH=arm-cortexa9_neon-linux-gnueabihf

PROCSERV_VERSION=${PROCSERV_VERSION=2.7.0-1.3.0}
PYTHON_VERSION=${PYTHON_VERSION=2.7.13}

pathmunge $PACKAGE_SITE_TOP/procServ/procServ-$PROCSERV_VERSION/install/$CROSS_ARCH/bin

pathmunge       $PACKAGE_SITE_TOP/python/python$PYTHON_VERSION/install/$CROSS_ARCH/bin
ldpathmunge     $PACKAGE_SITE_TOP/python/python$PYTHON_VERSION/install/$CROSS_ARCH/lib
pythonpathmunge $PACKAGE_SITE_TOP/python/python$PYTHON_VERSION/install/$CROSS_ARCH/lib/python2.7/site-packages
