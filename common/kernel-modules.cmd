# =========================================
# Set environment variables for kernel drivers
# =========================================
export TZ=PST8PDT

if [ -z "$IOC_COMMON" ]; then
	export IOC_COMMON=/reg/d/iocCommon
fi
if [ -z "$T_A" ]; then
	export T_A=rhel7-x86_64
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
	if [ -d $EDT_DRIVER/ ]; then
		echo Installing EDT driver: $EDT_DRIVER
		mkdir -p /opt/EDTpdv
		mount --bind $EDT_DRIVER /opt/EDTpdv
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

lspci_perle=`lspci -d 155f:* -n`
if [ "$lspci_perle" != "" ]; then
	if [ -n $PERLE_SERIAL_DRIVER -a -d $PERLE_SERIAL_DRIVER/ ]; then
		echo Installing PERLE driver: $PERLE_SERIAL_DRIVER
		insmod $PERLE_SERIAL_DRIVER/perle-serial.ko
	else
		echo Perle Serial driver dir not found: $PERLE_SERIAL_DRIVER
	fi
else
	echo Perle device not found.
fi

#lspci_megaraid=`lspci -d 1000:005d -n`
#if [ "$lspci_megaraid" != "" ]; then
#	if [ -n $MEGARAID_DRIVER -a -d $MEGARAID_DRIVER/ ]; then
#		echo Installing MegaRaid driver: $MEGARAID_DRIVER
#		insmod $MEGARAID_DRIVER/megaraid_sas.ko
#
#		#megaRAID command line utility
#		ln -s $MEGARAID_DRIVER/storcli64 /usr/bin/storcli64
#	else
#		echo Megaraid driver dir not found: $MEGARAID_DRIVER
#	fi
#else
#	echo MegaRaid device not found.
#fi

lspci_SLAC_pgp=`lspci -d 1a4a:2030 -n`
if [ "$lspci_SLAC_pgp" != "" ]; then
	if [ -n "$SLAC_DATADEV_DRIVER" -a -f $SLAC_DATADEV_DRIVER/datadev.ko ]; then
		if [ ! -n "foo" ]; then
			# Not temporarily disabled - bhill
			echo Temporarily NOT automatically Installing SLAC DATADEV driver: $SLAC_DATADEV_DRIVER
		else
			echo Installing SLAC DATADEV driver: $SLAC_DATADEV_DRIVER
			insmod $SLAC_DATADEV_DRIVER/datadev.ko cfgSize=0x50000 cfgRxCount=256 cfgTxCount=16
			chmod 666 /dev/datadev*
		fi
	else
		echo SLAC DATADEV driver dir not found: $SLAC_DATADEV_DRIVER
	fi
else
	echo SLAC DATADEV device not found.
fi

# Cleanup env so defaults won't stick during debugging
unset EDT_DRIVER;			unset EDT_VER
unset EV2_DRIVER;			unset EV2_VER;
unset MEGARAID_DRIVER;		unset MEGARAID_VER
unset PERLE_SERIAL_DRIVER;	unset PERLE_VER

# END of kernel-modules.cmd =========================================
