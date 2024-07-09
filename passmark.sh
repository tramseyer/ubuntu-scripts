#!/bin/bash -eux
export DEBIAN_FRONTEND=noninteractive

for arg in "$@"
do
    case $arg in
        -i)
        apt-get update -y
        apt-get install -y curl dmidecode python3 sudo wget
        shift
        ;;
    esac
done

mkdir -p pt_linux
cd pt_linux

PT_LINUX_ARCH=""

if dpkg --print-architecture | grep amd64; then
    wget -nv --backups=1 http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncursesw5_6.4-2_amd64.deb
    wget -nv --backups=1 http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.4-2_amd64.deb
    dpkg-deb -xv libncursesw5_6.4-2_amd64.deb libncursesw5
    dpkg-deb -xv libtinfo5_6.4-2_amd64.deb libtinfo5
    mv libncursesw5/lib/x86_64-linux-gnu/libncursesw.so.5.9 libncurses.so.5
    mv libtinfo5/lib/x86_64-linux-gnu/libtinfo.so.5.9 libtinfo.so.5
    PT_LINUX_ARCH="x64"
elif dpkg --print-architecture | grep arm64; then
    wget -nv --backups=1 http://ports.ubuntu.com/pool/main/n/ncurses/libncursesw5_6.1-1ubuntu1_arm64.deb
    wget -nv --backups=1 http://ports.ubuntu.com/pool/main/n/ncurses/libtinfo5_6.1-1ubuntu1_arm64.deb
    dpkg-deb -xv libncursesw5_6.1-1ubuntu1_arm64.deb libncursesw5
    dpkg-deb -xv libtinfo5_6.1-1ubuntu1_arm64.deb libtinfo5
    mv libncursesw5/lib/aarch64-linux-gnu/libncursesw.so.5.9 libncurses.so.5
    mv libtinfo5/lib/aarch64-linux-gnu/libtinfo.so.5.9 libtinfo.so.5
    PT_LINUX_ARCH="arm64"
fi

if [ ! -z "$PT_LINUX_ARCH" ]; then
    wget -nv --backups=1 "https://www.passmark.com/downloads/pt_linux_$PT_LINUX_ARCH.zip"
    python3 -c 'import sys; from zipfile import PyZipFile; PyZipFile(sys.argv[1]).extractall()' "pt_linux_$PT_LINUX_ARCH.zip"
    mv "PerformanceTest/pt_linux_$PT_LINUX_ARCH" .
    chmod a+x "pt_linux_$PT_LINUX_ARCH"
    TERM=xterm LD_LIBRARY_PATH="$(pwd)" "./pt_linux_$PT_LINUX_ARCH" -r 1
    grep -E "Processor:|NumCores:|NumLogicals:|Memory:" results_cpu.yml
    grep -E "CPU_SINGLETHREAD|SUMM_CPU" results_cpu.yml
fi

cd ..
rm -r pt_linux
