# =========================================
# Find the packages and driver paths
# =========================================
if [ "$PACKAGE_SITE_TOP" == "" ];
then
	PACKAGE_SITE_TOP=/reg/g/pcds/package
fi

# Select default Perle serial driver if not overridden
if [ "$PERLE_SERIAL_DRIVER" == "" ];
then
	if [ "$PERLE_VER" == "" ];
	then
		PERLE_VER=3.9.0-14
	fi
	PERLE_SERIAL_DRIVER=$PACKAGE_SITE_TOP/perle-serial/$PERLE_VER
fi

# Select default Megaraid driver if not overridden
if [ "$MEGARAID_DRIVER" == "" ];
then
	if [ "$MEGARAID_VER" == "" ];
	then
		MEGARAID_VER=06.806.08.00
	fi
	MEGARAID_DRIVER=$PACKAGE_SITE_TOP/megaRAID/$MEGARAID_VER
fi

# Select default EDT driver if not overridden
if [ "$EDT_DRIVER" == "" ];
then
	if [ "$EDT_VER" == "" ];
	then
		EDT_VER=5.4.5.1
	fi
	EDT_DRIVER=$PACKAGE_SITE_TOP/EdtPdv/$EDT_VER
fi

# Select default event2 driver if not overridden
if [ "$EVENT2_DRIVER" == "" ];
then
	if [ "$EVENT2_VER" == "" ];
	then
		EVENT2_VER=latest
	fi
	EVENT2_DRIVER=/reg/g/pcds/pacakge/epics/3.14/modules/event2/$EVENT2_VER/
fi

# =================================================
# Install the kernel drivers for installed hardware
# =================================================
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
fi

if [ -d $EDT_DRIVER ];
then
	lspci_edt=`lspci -d 123d:* -n`
	if [ "$lspci_edt" != "" ];
	then
		echo Installing EDT driver: $EDT_DRIVER
		mkdir -p /opt/EDTpdv
		busybox mount --bind $EDT_DRIVER /opt/EDTpdv
		/opt/EDTpdv/edtinit start
	else
		echo EDT framegrabber not found.
	fi
fi

if [ -d $EVENT2_DRIVER ];
then
	lspci_evr=`lspci -d 123d:* -n`
	if [ "$lspci_evr" != "" ];
	then
		echo Installing EVENT2 driver: $EVENT2_DRIVER
		$EVENT2_DRIVER/driver/evr_load_module
		if [ ! -e /dev/era0 ];
		then
			/sbin/rmmod evr_device
		fi
		if [ ! -e /dev/ega0 ];
		then
			/sbin/rmmod pci_mrfevg
		fi
	else
		echo EVR not found.
	fi
fi

# END of kernel-modules.cmd =========================================
