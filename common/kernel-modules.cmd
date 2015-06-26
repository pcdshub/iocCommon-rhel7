# =========================================
# Install the kernel drivers
# =========================================

if [ -d $PERLE_SERIAL_DRIVER ];
then
        echo Installing PERLE driver: $PERLE_SERIAL_DRIVER
        lspci_perle=`lspci -d 155f:* -n`
        if [ "$lspci_perle" != "" ];
        then
                insmod $PERLE_SERIAL_DRIVER/perle-serial.ko
        else
                echo Perle device not found.
        fi
fi

if [ -d $MEGARAID_DRIVER ];
then
        echo Installing MegaRaid driver: $MEGARAID_DRIVER
        lspci_megaraid=`lspci -d 1000:005d -n`
        if [ "$lspci_megaraid" != "" ];
        then
                insmod $MEGARAID_DRIVER/megaraid_sas.ko

                #megaRAID command line utility
                ln -s $MEGARAID_DRIVER/storcli64 /usr/bin/storcli64
        else
                echo MegaRaid device not found.
        fi
fi

if [ -d $EDT_DRIVER ];
then
        echo Installing EDT driver: $EDT_DRIVER
        lspci_edt=`lspci -d 123d:* -n`
        if [ "$lspci_edt" != "" ];
        then
                mkdir -p /opt/EDTpdv
                busybox mount --bind $EDT_DRIVER /opt/EDTpdv
                /opt/EDTpdv/edtinit start
        else
                echo EDT framegrabber not found.
        fi
fi

# END of kernel-modules.cmd =========================================
