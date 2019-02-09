# ====================================================================
# At the moment our embedded targets boot up with only one user account
# defined in the root file system:
#	username = laci, group = lcls, UID = 8412, GID = 2211
# ====================================================================

# Setup default profile scripts for users
if [ -f $IOC_COMMON/$T_A/facility/ioc_env.sh ]; then
	# =========================================
	# Setup environment for ioc users
	# =========================================
	if [ ! -e "/etc/profile.d" ]; then
		mkdir /etc/profile.d
	fi
	cp $IOC_COMMON/$T_A/facility/ioc_env.sh     /etc/profile.d/
	chmod 0777 /etc/profile.d/ioc_env.sh 
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
