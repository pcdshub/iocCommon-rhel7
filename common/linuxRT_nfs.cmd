# ==============================================================================
# NFS mounts
# ==============================================================================

# =============================================================
# Mount the IOC data area so that the IOC can write files.
# =============================================================
mkdir -p /reg/d/iocData
mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.76:/nfsexport/datapool/iocData   /reg/d/iocData

# =============================================================
# Note: /reg/d/iocCommon has already been mounted via ipxe.ini so
# /reg/d/iocCommon/linuxRT/common/startup.cmd can be run as BOOTFILE
# =============================================================

# ==============================================================================
# Mount PCDS home directories so IOC's can boot from developer's personal workspaces
# ==============================================================================

#mkdir -p  /reg/neh/home
#mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.28:/nfsexport/home   /reg/neh/home
#
#mkdir -p  /reg/neh/home1
#mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.28:/u2/users         /reg/neh/home1
#ln -s /reg/neh/home1 /home1
#
#mkdir -p  /reg/neh/home2
#mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.25:/u2/users         /reg/neh/home2
#ln -s /reg/neh/home2 /home2
#
#mkdir -p  /reg/neh/home3
#mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.47.25:/u2/users         /reg/neh/home3
#ln -s /reg/neh/home3 /home3

mkdir -p  /reg/neh/home4/mcbrowne
mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.32.81:/nfsexport/datapool/home4/mcbrowne /reg/neh/home4/mcbrowne
ln -s /reg/neh/home4 /home4

mkdir -p /reg/neh/home
ln -s /reg/neh/home4/mcbrowne /reg/neh/home/mcbrowne

mkdir -p  /reg/neh/home5/bhill
mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.32.80:/nfsexport/datapool/home5/bhill /reg/neh/home5/bhill
ln -s /reg/neh/home5 /home5

# =============================================================
# Mount PCDS package directories for drivers and IOC releases
# =============================================================

mkdir -p /reg/g/pcds
mount -o nolock,rw,hard,intr,vers=3 -t nfs 172.21.32.88:/nfsexport/datapool/pcds   /reg/g/pcds

mkdir -p /reg/common/package
mount -o nolock,ro,hard,intr,vers=3 -t nfs 172.21.32.88:/nfsexport/datapool/package   /reg/common/package

# End of file
