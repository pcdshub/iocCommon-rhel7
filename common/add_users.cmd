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
adduser -G ps-ioc -u 12958 auxioc -D
adduser -G ps-ioc -u 10668 cxiioc -D
adduser -G ps-ioc -u 13087 detioc -D
adduser -G ps-ioc -u 16909 kfeioc -D
adduser -G ps-ioc -u 10664 lasioc -D
adduser -G ps-ioc -u 16910 lfeioc -D
adduser -G ps-ioc -u 10669 mecioc -D
adduser -G ps-ioc -u 11926 thzioc -D
adduser -G ps-ioc -u 16914 tmoioc -D
adduser -G ps-ioc -u 11009 tstioc -D
adduser -G ps-ioc -u 10667 xcsioc -D
adduser -G ps-ioc -u 10666 xppioc -D

# Test only
#adduser -G ps-ioc -u 10174 bhill -D /home5/bhill

# End of file
