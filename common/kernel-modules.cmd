
# =========================================
# Set environment variables for kernel drivers
# =========================================
export BUILDROOT_T_A=buildroot-glibc-x86_64
#export KERNEL_DRIVER_HOME=$PACKAGE_SITE_TOP/linuxKernel_Modules
export KERNEL_DRIVER_HOME=/reg/neh/home/mdewart/workspace/linuxKernel_Modules

# =========================================
# Find the packages and driver paths, allowing override
# of the default driver version or path
# =========================================
source $IOC_COMMON/linuxRT/common/kernel-module-dirs.cmd

# =================================================
# Install the kernel drivers for installed hardware
# =================================================
if [ -d $EDT_DRIVER/ ];
then
	lspci_edt=`lspci -d 123d:* -n`
	if [ "$lspci_edt" != "" ];
	then
		echo Installing EDT driver: $EDT_DRIVER
		mkdir -p /opt/EDTpdv
		mount --bind $EDT_DRIVER /opt/EDTpdv
		/opt/EDTpdv/edtinit start
	else
		echo EDT framegrabber not found.
	fi
else
	echo EDT driver dir not found: $EDT_DRIVER
fi

if [ -d $EVENT2_DRIVER/ ];
then
	# Check for MRF EVR boards w/ PLX 9030 bridge
	lspci_mrf_evr=`lspci -d 10b5:9030 -n`
	# Also check for SLAC EVR
	lspci_slac_evr=`lspci -d 1a4a:2010 -n`
	if [ "$lspci_mrf_evr" != "" -o "$lspci_slac_evr" != "" ];
	then
		echo Installing EVENT2 driver: $EVENT2_DRIVER
		$EVENT2_DRIVER/driver/evr_load_module
		if [ -e /dev/era0 ];
		then
			chmod a+rw /dev/er*
		else
			/sbin/rmmod evr_device
		fi
		if [ -e /dev/ega0 ];
		then
			chmod a+rw /dev/eg*
		else
			/sbin/rmmod pci_mrfevg
		fi
	else
		echo EVR not found.
	fi
fi

if [ -d $PERLE_SERIAL_DRIVER ];
then
	lspci_perle=`lspci -d 155f:* -n`
	if [ "$lspci_perle" != "" ];
	then
		echo Installing PERLE driver: $PERLE_SERIAL_DRIVER
		insmod $PERLE_SERIAL_DRIVER/perle-serial.ko
	else
		echo Perle device not found.
	fi
else
	echo Perle Serial driver dir not found: $PERLE_SERIAL_DRIVER
fi

if [ -d $MEGARAID_DRIVER ];
then
	lspci_megaraid=`lspci -d 1000:005d -n`
	if [ "$lspci_megaraid" != "" ];
	then
		echo Installing MegaRaid driver: $MEGARAID_DRIVER
		insmod $MEGARAID_DRIVER/megaraid_sas.ko

		#megaRAID command line utility
		ln -s $MEGARAID_DRIVER/storcli64 /usr/bin/storcli64
	else
		echo MegaRaid device not found.
	fi
else
	echo Megaraid driver dir not found: $MEGARAID_DRIVER
fi


# Cleanup env so defaults won't stick during debugging
unset EDT_DRIVER;			unset EDT_VER
unset EVENT2_DRIVER;		unset EVENT2_VER
unset MEGARAID_DRIVER;		unset MEGARAID_VER
unset PERLE_SERIAL_DRIVER;	unset PERLE_VER

# END of kernel-modules.cmd =========================================
