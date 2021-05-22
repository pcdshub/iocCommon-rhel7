# ====================================================================
# At the moment our embedded targets boot up with only one user account
# defined in the root file system:
#	username = laci, group = lcls, UID = 8412, GID = 2211
# ====================================================================

# TODO:
# Look into using openldap for handling our user and group id's
# ====================================================================
# Create PCDS group
if ! grep ps-ioc /etc/group 2>1 > /dev/null; then
	addgroup -g 2341 ps-ioc
fi

# ====================================================================
# Create one userid for each hutch or beamline area
if ! id auxioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 12958 auxioc -D
fi
if ! id cxiioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 10668 cxiioc -D
fi
if ! id detioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 13087 detioc -D
fi
if ! id kfeioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 16909 kfeioc -D
fi
if ! id lasioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 10664 lasioc -D
fi
if ! id lfeioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 16910 lfeioc -D
fi
if ! id mecioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 10669 mecioc -D
fi
if ! id thzioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 11926 thzioc -D
fi
if ! id rixioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 16915 rixioc -D
fi
if ! id tmoioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 16914 tmoioc -D
fi
if ! id tstioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 11009 tstioc -D
fi
if ! id xcsioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 10667 xcsioc -D
fi
if ! id xppioc 2>1 > /dev/null; then
	adduser -G ps-ioc -u 10666 xppioc -D
fi

# Test only
#adduser -G ps-ioc -u 10174 bhill -D /home5/bhill

# End of file
