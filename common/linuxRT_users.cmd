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

# ====================================================================
# Create PCDS group
addgroup -g 2341 ps-ioc

# ====================================================================
# Create one userid for each hutch or beamline area
adduser -G ps-ioc -u 10404 amoioc -s $USER_SHELL -D; passwd -d amoioc
adduser -G ps-ioc -u 12958 auxioc -s $USER_SHELL -D; passwd -d auxioc
adduser -G ps-ioc -u 10668 cxiioc -s $USER_SHELL -D; passwd -d cxiioc
adduser -G ps-ioc -u 13087 detioc -s $USER_SHELL -D; passwd -d detioc
adduser -G ps-ioc -u 10403 feeioc -s $USER_SHELL -D; passwd -d feeioc
adduser -G ps-ioc -u 10664 lasioc -s $USER_SHELL -D; passwd -d lasioc
adduser -G ps-ioc -u 10669 mecioc -s $USER_SHELL -D; passwd -d mecioc
adduser -G ps-ioc -u 10665 sxrioc -s $USER_SHELL -D; passwd -d sxrioc
adduser -G ps-ioc -u 11926 thzioc -s $USER_SHELL -D; passwd -d thzioc
adduser -G ps-ioc -u 11009 tstioc -s $BASH_SHELL -D; passwd -d tstioc
adduser -G ps-ioc -u 10667 xcsioc -s $USER_SHELL -D; passwd -d xcsioc
adduser -G ps-ioc -u 10666 xppioc -s $USER_SHELL -D; passwd -d xppioc

# Test only
adduser -G ps-ioc -u 10174 bhill -s $BASH_SHELL -D -h /home2/bhill; passwd -d bhill

# End of file
