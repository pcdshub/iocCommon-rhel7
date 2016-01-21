# =========================================
# Setup environment for users
# =========================================
export TZ=PST8PDT

# Make sure we have the common directories defined
if [ -z "$IOC_COMMON" ]; then
	if [ -d /reg/g/pcds/setup ]; then
		source /reg/g/pcds/pyps/config/common_dirs.sh
	else
		source /afs/slac/g/pcds/config/common_dirs.sh
	fi
fi

# =================================================
# Install the PCDS linuxRT package
# =================================================
export PSPKG_RELEASE=linuxRT-0.0.3
export EXTRA_LD_LIBS=$IOC_COMMON/linuxRT/extralibs
source $PSPKG_ROOT/etc/set_env.sh

source $SETUP_SITE_TOP/epicsenv-3.14.12.sh
