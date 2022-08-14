if [ -s /odm/etc/wifi/bin_version ]; then
    system_version=`cat /odm/etc/wifi/bin_version`
    echo "system_version=$system_version"
    if [ ! -s /mnt/vendor/persist/bin_version ]; then
        cp /odm/etc/wifi/bin_version /mnt/vendor/persist/bin_version
        sync
    fi
else
    system_version=1
fi

if [ -s /mnt/vendor/persist/bin_version ]; then
    persist_version=`cat /mnt/vendor/persist/bin_version`
else
    persist_version=1
fi

#ifdef OPLUS_BUG_STABILITY
#chenxu@CONNECTIVITY.WIFI.BASIC. FCC use fcc sar bdf
#REGIONMARK=`getprop ro.vendor.oplus.regionmark`
#if [ "x${REGIONMARK}" == "xLATAM"  -o "x${REGIONMARK}" == "xMX" ]; then
#    elf_source_file=/odm/etc/wifi/bdwlan_fcc.elf
#else
#    elf_source_file=/odm/etc/wifi/bdwlan.elf
#fi
#endif OPLUS_BUG_STABILITY

elf_source_file=/odm/etc/wifi/bdwlan.elf
if [ ! -s /mnt/vendor/persist/bdwlan.elf  -o $system_version -gt $persist_version ]; then
    cp $elf_source_file /mnt/vendor/persist/bdwlan.elf
    echo "$system_version" > /mnt/vendor/persist/bin_version
    sync
fi

if [ $system_version -eq $persist_version ] ; then
    persistbdf=`md5sum /mnt/vendor/persist/bdwlan.elf |cut -d" " -f1`
    vendorbdf=`md5sum $elf_source_file |cut -d" " -f1`
    if [ x"$vendorbdf" != x"$persistbdf" ]; then
        cp $elf_source_file /mnt/vendor/persist/bdwlan.elf
        sync
        echo "bdf check"
    fi
fi

