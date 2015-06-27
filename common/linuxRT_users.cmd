# ====================================================================
# At the moment our linuxRT targets boot up with only one user account
# defined in the root file system:
#	username = laci, group = lcls, UID = 8412, GID = 2211
# ====================================================================

# ====================================================================
# Create PCDS group
addgroup -g 2341 ps-ioc

# ====================================================================
# Create one userid for each hutch or beamline area
adduser -G ps-ioc -u 10404 amoioc -D; passwd -d amoioc
adduser -G ps-ioc -u 12958 auxioc -D; passwd -d auxioc
adduser -G ps-ioc -u 10668 cxiioc -D; passwd -d cxiioc
adduser -G ps-ioc -u 13087 detioc -D; passwd -d detioc
adduser -G ps-ioc -u 10403 feeioc -D; passwd -d feeioc
adduser -G ps-ioc -u 10664 lasioc -D; passwd -d lasioc
adduser -G ps-ioc -u 10669 mecioc -D; passwd -d mecioc
adduser -G ps-ioc -u 10665 sxrioc -D; passwd -d sxrioc
adduser -G ps-ioc -u 11926 thzioc -D; passwd -d thzioc
adduser -G ps-ioc -u 11009 tstioc -D; passwd -d tstioc
adduser -G ps-ioc -u 10667 xcsioc -D; passwd -d xcsioc
adduser -G ps-ioc -u 10666 xppioc -D; passwd -d xppioc

# End of file
