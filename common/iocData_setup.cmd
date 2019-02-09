#!/bin/sh
IOC_HOST=`hostname -s`
if [ "$IOC_USER" == "" ]; then
	echo Warning: Set IOC_USER env variable in your startup.cmd file before running common_env.sh
else
	# Run processes as the correct IOC userid
	if [ -f /sbin/runuser ]; then
	    export RUNUSER="/sbin/runuser $IOC_USER -s /bin/bash --preserve-environment -c"
	else
	    export RUNUSER="su $IOC_USER -c"
	fi

	# Make sure the host iocData directory exists for the caRepeater log
	if [ ! -d $IOC_DATA/$IOC_HOST ]; then
		$RUNUSER "mkdir $IOC_DATA/$IOC_HOST"
		if [ -n "$(which setfacl)" ]; then
			$RUNUSER "setfacl -d -m group:ps-ioc:rwx $IOC_DATA/$IOC_HOST"
			$RUNUSER "setfacl    -m group:ps-ioc:rwx $IOC_DATA/$IOC_HOST"
		fi
		$RUNUSER "mkdir -p $IOC_DATA/$IOC_HOST/iocInfo"
		$RUNUSER "mkdir -p $IOC_DATA/$IOC_HOST/logs"
	fi

	# Make sure the soft ioc iocData directories exist and have the right permissions
	if [ "$IOC" == "" ]; then
		echo Warning: Set IOC env variable in your startup.cmd file before running common_env.sh
	elif [ ! -d $IOC_DATA/$IOC ]; then
		$RUNUSER "mkdir $IOC_DATA/$IOC"
		if [ -n "$(which setfacl)" ]; then
			$RUNUSER "setfacl -d -m group:ps-ioc:rwx $IOC_DATA/$IOC"
			$RUNUSER "setfacl    -m group:ps-ioc:rwx $IOC_DATA/$IOC"
		fi
		$RUNUSER "mkdir -p $IOC_DATA/$IOC/autosave"
		$RUNUSER "mkdir -p $IOC_DATA/$IOC/archive"
		$RUNUSER "mkdir -p $IOC_DATA/$IOC/iocInfo"
		$RUNUSER "mkdir -p $IOC_DATA/$IOC/logs"
		$RUNUSER "chmod ug+w -R $IOC_DATA/$IOC"
	fi
fi
