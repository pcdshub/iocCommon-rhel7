# =========================================
# Set environment variables for kernel drivers
# =========================================
export TZ=PST8PDT

# =========================================
# Find the packages and driver paths, allowing override
# of the default driver version or path
# =========================================
source $IOC_COMMON/$T_A/common/kernel-module-dirs.cmd

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

# Cleanup env so defaults won't stick during debugging
unset EDT_DRIVER;			unset EDT_VER
unset EVENT2_DRIVER;		unset EVENT2_VER
unset MEGARAID_DRIVER;		unset MEGARAID_VER
unset PERLE_SERIAL_DRIVER;	unset PERLE_VER

# END of kernel-modules.cmd =========================================
