if uname -a | grep -q "Android"; then
    echo "运行环境正确"
else
    echo "您的会话正处于 proot 容器内"
    exit 1
fi

AH=$(uname -m)
sys_name="bookworm"
BAGNAME="rootfs.tar.xz"
SLEEP_TIME=0.1

if [ "$AH" = "aarch64" ]; then
    AH="arm64"
elif [ "$AH" = "x86_64" ]; then
    AH="amd64"
fi

cd ~

# Fork from https://github.com/termux/proot-distro
setup_fake_proc() {
	mkdir -p "$sys_name-$AH/etc/proc"
	chmod 700 "$sys_name-$AH/etc/proc"

	if [ ! -f "$sys_name-$AH/etc/proc/.loadavg" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.loadavg"
		0.12 0.07 0.02 2/165 765
		EOF
	fi

	if [ ! -f "$sys_name-$AH/etc/proc/.stat" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.stat"
		cpu  1957 0 2877 93280 262 342 254 87 0 0
		cpu0 31 0 226 12027 82 10 4 9 0 0
		cpu1 45 0 664 11144 21 263 233 12 0 0
		cpu2 494 0 537 11283 27 10 3 8 0 0
		cpu3 359 0 234 11723 24 26 5 7 0 0
		cpu4 295 0 268 11772 10 12 2 12 0 0
		cpu5 270 0 251 11833 15 3 1 10 0 0
		cpu6 430 0 520 11386 30 8 1 12 0 0
		cpu7 30 0 172 12108 50 8 1 13 0 0
		intr 127541 38 290 0 0 0 0 4 0 1 0 0 25329 258 0 5777 277 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
		ctxt 140223
		btime 1680020856
		processes 772
		procs_running 2
		procs_blocked 0
		softirq 75663 0 5903 6 25375 10774 0 243 11685 0 21677
		EOF
	fi

	if [ ! -f "$sys_name-$AH/etc/proc/.uptime" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.uptime"
		124.08 932.80
		EOF
	fi

	if [ ! -f "$sys_name-$AH/etc/proc/.version" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.version"
		Linux version ${DEFAULT_FAKE_KERNEL_VERSION} (proot@termux) (gcc (GCC) 12.2.1 20230201, GNU ld (GNU Binutils) 2.40) #1 SMP PREEMPT_DYNAMIC Wed, 01 Mar 2023 00:00:00 +0000
		EOF
	fi

	if [ ! -f "$sys_name-$AH/etc/proc/.vmstat" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.vmstat"
		nr_free_pages 1743136
		nr_zone_inactive_anon 179281
		nr_zone_active_anon 7183
		nr_zone_inactive_file 22858
		nr_zone_active_file 51328
		nr_zone_unevictable 642
		nr_zone_write_pending 0
		nr_mlock 0
		nr_bounce 0
		nr_zspages 0
		nr_free_cma 0
		numa_hit 1259626
		numa_miss 0
		numa_foreign 0
		numa_interleave 720
		numa_local 1259626
		numa_other 0
		nr_inactive_anon 179281
		nr_active_anon 7183
		nr_inactive_file 22858
		nr_active_file 51328
		nr_unevictable 642
		nr_slab_reclaimable 8091
		nr_slab_unreclaimable 7804
		nr_isolated_anon 0
		nr_isolated_file 0
		workingset_nodes 0
		workingset_refault_anon 0
		workingset_refault_file 0
		workingset_activate_anon 0
		workingset_activate_file 0
		workingset_restore_anon 0
		workingset_restore_file 0
		workingset_nodereclaim 0
		nr_anon_pages 7723
		nr_mapped 8905
		nr_file_pages 253569
		nr_dirty 0
		nr_writeback 0
		nr_writeback_temp 0
		nr_shmem 178741
		nr_shmem_hugepages 0
		nr_shmem_pmdmapped 0
		nr_file_hugepages 0
		nr_file_pmdmapped 0
		nr_anon_transparent_hugepages 1
		nr_vmscan_write 0
		nr_vmscan_immediate_reclaim 0
		nr_dirtied 0
		nr_written 0
		nr_throttled_written 0
		nr_kernel_misc_reclaimable 0
		nr_foll_pin_acquired 0
		nr_foll_pin_released 0
		nr_kernel_stack 2780
		nr_page_table_pages 344
		nr_sec_page_table_pages 0
		nr_swapcached 0
		pgpromote_success 0
		pgpromote_candidate 0
		nr_dirty_threshold 356564
		nr_dirty_background_threshold 178064
		pgpgin 890508
		pgpgout 0
		pswpin 0
		pswpout 0
		pgalloc_dma 272
		pgalloc_dma32 261
		pgalloc_normal 1328079
		pgalloc_movable 0
		pgalloc_device 0
		allocstall_dma 0
		allocstall_dma32 0
		allocstall_normal 0
		allocstall_movable 0
		allocstall_device 0
		pgskip_dma 0
		pgskip_dma32 0
		pgskip_normal 0
		pgskip_movable 0
		pgskip_device 0
		pgfree 3077011
		pgactivate 0
		pgdeactivate 0
		pglazyfree 0
		pgfault 176973
		pgmajfault 488
		pglazyfreed 0
		pgrefill 0
		pgreuse 19230
		pgsteal_kswapd 0
		pgsteal_direct 0
		pgsteal_khugepaged 0
		pgdemote_kswapd 0
		pgdemote_direct 0
		pgdemote_khugepaged 0
		pgscan_kswapd 0
		pgscan_direct 0
		pgscan_khugepaged 0
		pgscan_direct_throttle 0
		pgscan_anon 0
		pgscan_file 0
		pgsteal_anon 0
		pgsteal_file 0
		zone_reclaim_failed 0
		pginodesteal 0
		slabs_scanned 0
		kswapd_inodesteal 0
		kswapd_low_wmark_hit_quickly 0
		kswapd_high_wmark_hit_quickly 0
		pageoutrun 0
		pgrotated 0
		drop_pagecache 0
		drop_slab 0
		oom_kill 0
		numa_pte_updates 0
		numa_huge_pte_updates 0
		numa_hint_faults 0
		numa_hint_faults_local 0
		numa_pages_migrated 0
		pgmigrate_success 0
		pgmigrate_fail 0
		thp_migration_success 0
		thp_migration_fail 0
		thp_migration_split 0
		compact_migrate_scanned 0
		compact_free_scanned 0
		compact_isolated 0
		compact_stall 0
		compact_fail 0
		compact_success 0
		compact_daemon_wake 0
		compact_daemon_migrate_scanned 0
		compact_daemon_free_scanned 0
		htlb_buddy_alloc_success 0
		htlb_buddy_alloc_fail 0
		cma_alloc_success 0
		cma_alloc_fail 0
		unevictable_pgs_culled 27002
		unevictable_pgs_scanned 0
		unevictable_pgs_rescued 744
		unevictable_pgs_mlocked 744
		unevictable_pgs_munlocked 744
		unevictable_pgs_cleared 0
		unevictable_pgs_stranded 0
		thp_fault_alloc 13
		thp_fault_fallback 0
		thp_fault_fallback_charge 0
		thp_collapse_alloc 4
		thp_collapse_alloc_failed 0
		thp_file_alloc 0
		thp_file_fallback 0
		thp_file_fallback_charge 0
		thp_file_mapped 0
		thp_split_page 0
		thp_split_page_failed 0
		thp_deferred_split_page 1
		thp_split_pmd 1
		thp_scan_exceed_none_pte 0
		thp_scan_exceed_swap_pte 0
		thp_scan_exceed_share_pte 0
		thp_split_pud 0
		thp_zero_page_alloc 0
		thp_zero_page_alloc_failed 0
		thp_swpout 0
		thp_swpout_fallback 0
		balloon_inflate 0
		balloon_deflate 0
		balloon_migrate 0
		swap_ra 0
		swap_ra_hit 0
		ksm_swpin_copy 0
		cow_ksm 0
		zswpin 0
		zswpout 0
		direct_map_level2_splits 29
		direct_map_level3_splits 0
		nr_unstable 0
		EOF
	fi

	if [ ! -f "$sys_name-$AH/etc/proc/.sysctl_entry_cap_last_cap" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.sysctl_entry_cap_last_cap"
		40
		EOF
	fi

    if [ ! -f "$sys_name-$AH/etc/proc/.sysctl_entry_cap_last_cap" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.sysctl_entry_cap_last_cap"
		40
		EOF
	fi

    if [ ! -f "$sys_name-$AH/etc/proc/.bus/input/devices" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.bus/input/devices"
		I: Bus=0019 Vendor=0000 Product=0001 Version=0000
        N: Name="Power Button"
        P: Phys=LNXPWRBN/button/input0
        S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
        U: Uniq=
        H: Handlers=kbd event0 
        B: PROP=0
        B: EV=3
        B: KEY=10000000000000 0

        I: Bus=0003 Vendor=0627 Product=0001 Version=0001
        N: Name="QEMU QEMU USB Tablet"
        P: Phys=usb-0000:00:01.2-1/input0
        S: Sysfs=/devices/pci0000:00/0000:00:01.2/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input1
        U: Uniq=28754-0000:00:01.2-1
        H: Handlers=mouse0 event1 js0 
        B: PROP=0
        B: EV=1f
        B: KEY=70000 0 0 0 0
        B: REL=100
        B: ABS=3
        B: MSC=10

        I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
        N: Name="AT Translated Set 2 keyboard"
        P: Phys=isa0060/serio0/input0
        S: Sysfs=/devices/platform/i8042/serio0/input/input2
        U: Uniq=
        H: Handlers=kbd leds event2 
        B: PROP=0
        B: EV=120013
        B: KEY=402000000 3803078f800d001 feffffdfffefffff fffffffffffffffe
        B: MSC=10
        B: LED=7

        I: Bus=0011 Vendor=0002 Product=0013 Version=0006
        N: Name="VirtualPS/2 VMware VMMouse"
        P: Phys=isa0060/serio1/input1
        S: Sysfs=/devices/platform/i8042/serio1/input/input5
        U: Uniq=
        H: Handlers=mouse1 event3 js1 
        B: PROP=0
        B: EV=f
        B: KEY=70000 0 0 0 0
        B: REL=100
        B: ABS=3

        I: Bus=0011 Vendor=0002 Product=0013 Version=0006
        N: Name="VirtualPS/2 VMware VMMouse"
        P: Phys=isa0060/serio1/input0
        S: Sysfs=/devices/platform/i8042/serio1/input/input4
        U: Uniq=
        H: Handlers=mouse2 event4 
        B: PROP=1
        B: EV=7
        B: KEY=30000 0 0 0 0
        B: REL=3

        I: Bus=0010 Vendor=001f Product=0001 Version=0100
        N: Name="PC Speaker"
        P: Phys=isa0061/input0
        S: Sysfs=/devices/platform/pcspkr/input/input6
        U: Uniq=
        H: Handlers=kbd event5 
        B: PROP=0
        B: EV=40001
        B: SND=6

        I: Bus=0000 Vendor=0000 Product=0000 Version=0000
        N: Name="Android Power Button"
        P: Phys=
        S: Sysfs=/devices/virtual/input/input7
        U: Uniq=
        H: Handlers=kbd event6 
        B: PROP=0
        B: EV=3
        B: KEY=8000 10000000000000 0
		EOF
	fi

    if [ ! -f "$sys_name-$AH/etc/proc/.modules" ]; then
		cat <<- EOF > "$sys_name-$AH/etc/proc/.modules"
		bluetooth 552960 0 - Live 0x0000000000000000
        ecdh_generic 24576 1 bluetooth, Live 0x0000000000000000
        tcp_diag 16384 0 - Live 0x0000000000000000
        inet_diag 24576 1 tcp_diag, Live 0x0000000000000000
        virt_wifi 20480 0 - Live 0x0000000000000000
        cfg80211 671744 1 virt_wifi, Live 0x0000000000000000
        sdcardfs 61440 191 - Live 0x0000000000000000
        parport_pc 24576 0 - Live 0x0000000000000000
        parport 32768 1 parport_pc, Live 0x0000000000000000
        crc32c_intel 24576 0 - Live 0x0000000000000000
        crc32_pclmul 16384 0 - Live 0x0000000000000000
        ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
        e1000 139264 0 - Live 0x0000000000000000
        i2c_piix4 24576 0 - Live 0x0000000000000000
        9pnet_virtio 20480 0 - Live 0x0000000000000000
        9pnet 81920 1 9pnet_virtio, Live 0x0000000000000000
        pcspkr 16384 0 - Live 0x0000000000000000
        joydev 20480 0 - Live 0x0000000000000000
        psmouse 147456 0 - Live 0x0000000000000000
        mac_hid 16384 0 - Live 0x0000000000000000
        atkbd 28672 0 - Live 0x0000000000000000
        efi_pstore 16384 0 - Live 0x0000000000000000
        efivars 20480 1 efi_pstore, Live 0x0000000000000000
		EOF
	fi
}

# 检测是否安装过
if [ -f "$sys_name-$AH/root/.bashrc" ]; then
    echo -e "现在可以执行 ./$sys_name-$AH.sh 运行 $sys_name-$AH系统"
    exit 1
else
    echo 正在安装依赖
fi

mkdir $sys_name-$AH

echo "正在切换apt镜像源"

echo "deb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main" > $PREFIX/etc/apt/sources.list

apt update
apt install neofetch wget aria2 proot git -y


echo "即将下载安装$sys_name"
wget -O default.html "https://mirrors.bfsu.edu.cn/lxc-images/images/debian/$sys_name/$AH/default"
target=$(grep -m 1 -o '<td class="link"><a href=".*" title="' "default.html"| sed 's/<[^>]*>//g')
date="${target:9:-10}"
rm -rf default.html
DEF_CUR="https://mirrors.bfsu.edu.cn/lxc-images/images/debian/$sys_name/$AH/default/$date/rootfs.tar.xz"
echo "======================================="
echo "==============开始下载================="

echo $DEF_CUR
echo "======================================="


# 下载rootfs
if [ -e ${BAGNAME} ]; then
    tar -xvf rootfs.tar.xz -C $sys_name-$AH
else
	wget ${DEF_CUR}
	tar -xvf rootfs.tar.xz -C $sys_name-$AH
rm -rf ${BAGNAME}
echo -e "$sys_name-$AH 系统已下载，文件夹名为$sys_name-$AH"
fi
sleep $SLEEP_TIME

# 配置容器
neofetch >>systeminfo.log
hostinfo=$(cat systeminfo.log |grep Host |awk -F':' '{print $2}')
echo "更新DNS"
sleep $SLEEP_TIME
echo "127.0.0.1 localhost" > $sys_name-$AH/etc/hosts
rm $sys_name-$AH/etc/hostname
echo "$hostinfo" > $sys_name-$AH/etc/hostname
echo "127.0.0.1 $hostinfo" > $sys_name-$AH/etc/hosts
rm -rf $sys_name-$AH/etc/resolv.conf &&
echo "nameserver 223.5.5.5
nameserver 223.6.6.6
nameserver 114.114.114.114" >$sys_name-$AH/etc/resolv.conf
echo "设置时区"
sleep $SLEEP_TIME
rm systeminfo.log
echo "export  TZ='Asia/Shanghai'" >> $sys_name-$AH/root/.bashrc
echo "export  TZ='Asia/Shanghai'" >> $sys_name-$AH/etc/profile
echo "export PULSE_SERVER=tcp:127.0.0.1:4173" >> $sys_name-$AH/etc/profile
echo "export PULSE_SERVER=tcp:127.0.0.1:4173" >> $sys_name-$AH/root/.bashrc
echo 检测到你没有权限读取/proc内的所有文件
echo 将自动伪造新文件
mkdir proot_proc
aria2c -o proc.tar.xz -d ./proot_proc/ -x 16 https://gitee.com/yudezeng/proot_proc/raw/master/proc.tar.xz
sleep $SLEEP_TIME
mkdir tmp
echo 正在解压伪造文件

tar -xvJf proot_proc/proc.tar.xz -C tmp 
cp -r tmp/usr/local/etc/tmoe-linux/proot_proc tmp/
sleep $SLEEP_TIME
echo 复制文件
cp -r tmp/proot_proc $sys_name-$AH/etc/proc
sleep $SLEEP_TIME
echo 删除缓存
rm proot_proc tmp -rf
if grep -q 'ubuntu' "$sys_name-$AH/etc/os-release" ; then
    touch "$sys_name-$AH/root/.hushlogin"
fi

sleep $SLEEP_TIME

echo "写入启动脚本"
echo "为了兼容性考虑已将内核信息伪造成5.17.18-perf"

sleep $SLEEP_TIME
cat > $sys_name-$AH.sh <<- EOM
#!/bin/bash
unset LD_PRELOAD
proot \
 --bind=/vendor \
 --bind=/system \
 --bind=/data/data/com.termux/files/usr \
 --bind=/storage \
 --bind=/storage/self/primary:/sdcard \
 --bind=/data/data/com.termux/files/home \
 --bind=/data/data/com.termux/cache \
 --bind=/data/dalvik-cache \
 --bind=$sys_name-$AH/tmp:/dev/shm \
 --bind=$sys_name-$AH/etc/proc/.sysctl_entry_cap_last_cap:/proc/sys/kernel/cap_last_cap
 --bind=$sys_name-$AH/etc/proc/.vmstat:/proc/vmstat \
 --bind=$sys_name-$AH/etc/proc/.version:/proc/version \
 --bind=$sys_name-$AH/etc/proc/.uptime:/proc/uptime \
 --bind=$sys_name-$AH/etc/proc/.stat:/proc/stat \
 --bind=$sys_name-$AH/etc/proc/.loadavg:/proc/loadavg  \
 --bind=$sys_name-$AH/etc/proc/.bus/input/devices:/proc/bus/input/devices \
 --bind=$sys_name-$AH/etc/proc/.modules:/proc/modules   \
 --bind=/sys \
 --bind=/proc/self/fd/2:/dev/stderr \
 --bind=/proc/self/fd/1:/dev/stdout \
 --bind=/proc/self/fd/0:/dev/stdin \
 --bind=/proc/self/fd:/dev/fd \
 --bind=/proc \
 --bind=/dev/urandom:/dev/random \
 --bind=/data/data/com.termux/files/usr/tmp:/tmp \
 --bind=/data/data/com.termux/files:$sys_name-$AH/termux \
 --bind=/dev \
 --root-id \
 --cwd=/root \
 -L \
 --kernel-release=5.17.18-perf \
 --sysvipc \
 --link2symlink \
 --kill-on-exit \
 --rootfs=$sys_name-$AH/ /usr/bin/env -i HOME=/root LANG=zh_CN.UTF-8 TERM=xterm-256color /bin/su -l root
EOM

echo "授予启动脚本执行权限"
chmod +x $sys_name-$AH.sh
echo -e "现在可以执行 ./$sys_name-$AH.sh 运行 $sys_name-$AH系统"