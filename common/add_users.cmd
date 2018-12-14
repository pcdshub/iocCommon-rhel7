# ====================================================================
# At the moment our linuxRT targets boot up with only one user account
# defined in the root file system:
#	username = laci, group = lcls, UID = 8412, GID = 2211
# ====================================================================

# ====================================================================
# Set the default shell for ioc userid's
#BASH_SHELL=/reg/g/pcds/pkg_mgr/release/linuxRT-0.0.3/x86_64-rhel6-gcc44-opt/bin/bash
USER_SHELL=/bin/sh
if which bash 2>&1 /dev/null; then
	USER_SHELL=/bin/sh
else
	BASH_SHELL=$(which bash)
	if [ X$BASH_SHELL != X ]; then
	    BASH_SHELL=/bin/sh
	fi
	# Do we want to do this?
	#USER_SHELL=$BASH_SHELL
fi

echo Default USER_SHELL set to: $USER_SHELL

if [ -n "$BASH_SHELL" ]; then
	# Add bash shell to list of authorized shells besides /bin/sh and /bin/csh
	echo /bin/sh		>> /etc/shells
	echo /bin/csh		>> /etc/shells
	echo $USER_SHELL	>> /etc/shells
	echo $BASH_SHELL	>> /etc/shells
fi

# TODO:
# Look into using openldap for handling our user and group id's
# ====================================================================
# Create PCDS group
addgroup -g 2341 ps-ioc

# ====================================================================
# Create one userid for each hutch or beamline area
adduser -G ps-ioc -u 10404 amoioc -s $USER_SHELL -D; passwd amoioc
adduser -G ps-ioc -u 12958 auxioc -s $USER_SHELL -D; passwd auxioc
adduser -G ps-ioc -u 10668 cxiioc -s $USER_SHELL -D; passwd cxiioc
adduser -G ps-ioc -u 13087 detioc -s $USER_SHELL -D; passwd detioc
adduser -G ps-ioc -u 10403 feeioc -s $USER_SHELL -D; passwd feeioc
adduser -G ps-ioc -u 10664 lasioc -s $USER_SHELL -D; passwd lasioc
adduser -G ps-ioc -u 10669 mecioc -s $USER_SHELL -D; passwd mecioc
adduser -G ps-ioc -u 10665 sxrioc -s $USER_SHELL -D; passwd sxrioc
adduser -G ps-ioc -u 11926 thzioc -s $USER_SHELL -D; passwd thzioc
adduser -G ps-ioc -u 11009 tstioc -s $BASH_SHELL -D; passwd tstioc
adduser -G ps-ioc -u 10667 xcsioc -s $USER_SHELL -D; passwd xcsioc
adduser -G ps-ioc -u 10666 xppioc -s $USER_SHELL -D; passwd xppioc

# Test only
adduser -G ps-ioc -u 10174 bhill -s $BASH_SHELL -D -h /home5/bhill; passwd bhill slac

# End of file
