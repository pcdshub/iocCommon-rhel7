# =========================================
# Setup environment for users
# =========================================
export TZ=PST8PDT

# Make sure we have the common directories defined
if [ -z "$IOC_COMMON" ]; then
	if [ -d /reg/g/pcds/setup ]; then
		source /reg/g/pcds/pyps/config/common_dirs.sh
	elif [ -f  /afs/slac/g/pcds/config/common_dirs.sh ]; then
		source /afs/slac/g/pcds/config/common_dirs.sh
	fi
fi

if [ -n "$IOC_COMMON" -a "$PSPKG_ROOT" ]; then
	# =================================================
	# Install the PCDS linuxRT package
	# =================================================
	export PSPKG_RELEASE=linuxRT-0.0.3
	export EXTRA_LD_LIBS=$IOC_COMMON/linuxRT/extralibs
	source $PSPKG_ROOT/etc/set_env.sh
fi

if [ -f "$SETUP_SITE_TOP/epicsenv-cur.sh" ]; then
	# Select EPICS environment
	source $SETUP_SITE_TOP/epicsenv-cur.sh
fi
