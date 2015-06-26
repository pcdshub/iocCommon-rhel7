# =========================================
# Find the packages and driver paths
# =========================================
if [ "$PACKAGE_SITE_TOP" == "" ];
then
	PACKAGE_SITE_TOP=/reg/g/pcds/package
fi

if [ "$PERLE_SERIAL_DRIVER" == "" ];
then
	if [ "$PERLE_VER" == "" ];
	then
		PERLE_VER=3.9.0-14
	fi
	PERLE_SERIAL_DRIVER=$PACKAGE_SITE_TOP/perle-serial/$PERLE_VER
fi

if [ "$MEGARAID_DRIVER" == "" ];
then
	if [ "$MEGARAID_VER" == "" ];
	then
		MEGARAID_VER=3.9.0-14
	fi
	MEGARAID_DRIVER=$PACKAGE_SITE_TOP/megaRAID/$MEGARAID_VER
fi

if [ "$EDT_DRIVER" == "" ];
then
	if [ "$EDT_VER" == "" ];
	then
		EDT_VER=5.4.5.1
	fi
	EDT_DRIVER=$PACKAGE_SITE_TOP/EdtPdv/$EDT_VER
fi

# =========================================
# Install the kernel drivers
# =========================================
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

# END of kernel-modules.cmd =========================================
