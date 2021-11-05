# =========================================
# Set environment variables for kernel drivers
# =========================================
export TZ=PST8PDT

if [ -z "$IOC_COMMON" ]; then
	export IOC_COMMON=/reg/d/iocCommon
fi
if [ -z "$T_A" ]; then
	export T_A=linux-x86_64
fi
# =========================================
# Find the packages and driver paths, allowing override
# of the default driver version or path
# =========================================
source $IOC_COMMON/$T_A/common/kernel-module-dirs.cmd

# =================================================
# Install the kernel drivers for installed hardware
# =================================================
lspci_edt=`lspci -d 123d:* -n`
if [ "$lspci_edt" != "" ]; then
	if [ -d $EDT_DRIVER/ -a ! -e /dev/edt0 -a $UID -eq 0 ]; then
		echo Installing EDT driver: $EDT_DRIVER
		if [ ! -e /opt/EDTpdv/version -o "R$(cat /opt/EDTpdv/version)" != "${EDT_VER}" ]; then
			mkdir -p /opt/EDTpdv
			mount --bind $EDT_DRIVER /opt/EDTpdv
			mount --bind $PACKAGE_SITE_TOP/EDTpdv/${EDT_VER}/pdv /opt/pdv
		fi
		/opt/EDTpdv/edtinit.sh start
	else
		echo EDT driver dir not found: $EDT_DRIVER
	fi
else
	echo EDT framegrabber not found.
fi

# Check for MRF EVR boards w/ PLX 9030 bridge
lspci_mrf_evr=`lspci -d 10b5:9030 -n`
# Also check for SLAC EVR
lspci_slac_evr=`lspci -d 1a4a:2010 -n`
if [ "$lspci_mrf_evr" != "" -o "$lspci_slac_evr" != "" ]; then
	if [ -n "$EV2_DRIVER" -a -d $EV2_DRIVER/ ]; then
		echo Installing EVENT2 driver: $EV2_DRIVER
		$EV2_DRIVER/driver/evr_load_module
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
		echo event2 driver dir not found: $EV2_DRIVER
	fi
else
	echo EVR not found.
fi


# Cleanup env so defaults won't stick during debugging
unset EDT_DRIVER;			unset EDT_VER
unset EV2_DRIVER;			unset EV2_VER;
unset MEGARAID_DRIVER;		unset MEGARAID_VER
unset PERLE_SERIAL_DRIVER;	unset PERLE_VER

# END of kernel-modules.cmd =========================================
