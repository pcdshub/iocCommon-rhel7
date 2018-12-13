# Select default EDT driver if not overridden
if [ "$EDT_DRIVER" == "" ];
then
	if [ "$EDT_VER" == "" ];
	then
		EDT_VER=R5.4.5.1
	fi
	#EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER/$T_A
	EDT_DRIVER=$PACKAGE_SITE_TOP/EDTpdv/$EDT_VER
fi

# Select default event2 driver if not overridden
if [ "$EVENT2_DRIVER" == "" ];
then
	if [ "$EVENT2_VER" == "" ];
	then
		EVENT2_VER=latest
	fi
	EVENT2_DRIVER=$EPICS_SITE_TOP/modules/event2/$EVENT2_VER/
fi
