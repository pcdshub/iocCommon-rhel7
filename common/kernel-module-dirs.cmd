# Select default EDT driver if not overridden
if [ "$EDT_DRIVER" == "" ];
then
	if [ "$EDT_VER" == "" ];
	then
		EDT_VER=R5.4.9.6
	fi
	EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER/`uname -r`
fi

# Select default event2 driver if not overridden
if [ "$EVENT2_DRIVER" == "" ];
then
	if [ "$EVENT2_VER" == "" ];
	then
		EVENT2_VER=drivers_current
	fi
	EVENT2_DRIVER=$EPICS_SITE_TOP/modules/event2/$EVENT2_VER/
fi

# Select default Perle serial driver if not overridden
if [ "$PERLE_SERIAL_DRIVER" == "" ];
then
	if [ "$PERLE_VER" == "" ];
	then
#		PERLE_VER=3.9.0-14
		PERLE_VER=$BUILDROOT_T_A
	fi
	PERLE_SERIAL_DRIVER=$KERNEL_DRIVER_HOME/perle-serial/$PERLE_VER
fi

# Select default Megaraid driver if not overridden
if [ "$MEGARAID_DRIVER" == "" ];
then
	if [ "$MEGARAID_VER" == "" ];
	then
#		MEGARAID_VER=06.806.08.00
		MEGARAID_VER=$BUILDROOT_T_A
	fi
	MEGARAID_DRIVER=$KERNEL_DRIVER_HOME/megaRAID/$MEGARAID_VER
fi

