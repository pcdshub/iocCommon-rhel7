# ==============================================================================
# linuxRT targets boot as diskless clients
#
# Let's setup some additional NFS Mount Points for linuxRT:
# ==============================================================================


# =====================================================================================================
# At the moment our linuxRT targets boot up with only one user account
# defined in the root file system: username = laci, group = lcls
# Can you add laci to your ldap  as,  UID = 8412,  GID = 2211 ?

# Use the "laci account" NFS user and group id  for linuxRT (uid=8412, gid=2211)
# I will first need the initial  "startup.cmd"
# =====================================================================================================

# =====================================================================================================
# Add username = tstioc, group = ps-ioc, UID = 11009, GID = 2341
# Other usernames will be amoioc, auxioc, cxiioc, detioc, feeioc, lasioc, mecioc, ...
# =====================================================================================================

# Create PCDS groups and user id's
# Create ps-ioc group and one userid for each hutch or beamline area
addgroup -g 2341 ps-ioc
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


# =====================================================================================================
# Mount the Development data area so that the IOC can write files.
# =====================================================================================================

#These should be read only:
# So, folks can develop and boot out of their home directories
mkdir -p  /reg/neh/home1
busybox mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.28:/u2/users         /reg/neh/home1

mkdir -p  /reg/neh/home
busybox mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.28:/nfsexport/home   /reg/neh/home

mkdir -p  /reg/neh/home2
busybox mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.25:/u2/users         /reg/neh/home2

mkdir -p /reg/g/pcds
busybox mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.28:/nfsexport/pcds   /reg/g/pcds

mkdir -p /reg/common/package
busybox mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.32.28:/nfsexport/package   /reg/common/package

mkdir -p /reg/d/iocData
busybox mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.20:/nfsexport/iocData   /reg/d/iocData

ln -s /reg/neh/home1 /home1
ln -s /reg/neh/home2 /home2

# End of file
