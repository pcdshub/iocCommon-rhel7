if [ -z "$EPICS_SITE_TOP" ]; then
	EPICS_SITE_TOP=/reg/g/pcds/epics
fi
if [ -z "$PACKAGE_SITE_TOP" ]; then
	PACKAGE_SITE_TOP=/reg/g/pcds/package
fi

# Select default EDT driver if not overridden
if [ "$EDT_DRIVER" == "" ];
then
	if [ "$EDT_VER" == "" ];
	then
		EDT_VER=R5.5.1.6
	fi
	#EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER/$T_A
	#EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER
	EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER/`uname -r`
fi
export EDT_DRIVER

# Select default ev2 driver if not overridden
if [ "$EV2_DRIVER" == "" ];
then
	if [ "$EV2_VER" == "" ];
	then
		EV2_VER=latest
	fi
	EV2_DRIVER=$EPICS_SITE_TOP/R3.14.12-0.4.0/modules/ev2_driver/$EV2_VER/
fi
export EV2_DRIVER

# Select default SLAC DATADEV driver if not overridden
if [ "$SLAC_DATADEV_DRIVER" == "" ];
then
	if [ "$SLAC_DATADEV_VER" == "" ];
	then
		SLAC_DATADEV_VER=latest
		#SLAC_DATADEV_VER=R5.6.0-0.0.0
	fi
	SLAC_DATADEV_DRIVER=$PACKAGE_SITE_TOP/slaclab/aes-stream-drivers/$SLAC_DATADEV_VER/install/`uname -r`/
fi
export SLAC_DATADEV_DRIVER
