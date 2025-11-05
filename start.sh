#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "权限不足 $(id -u)"
    exec sudo bash "$0" "$@"
fi
apt update -y
apt install build-essential -y

if command -v make &> /dev/null; then
    echo "make 版本：$(make --version | head -n1)"
else
    exit 1
fi
if command -v tar &> /dev/null; then
    tar -xjvf ssh.tar.bz2
else
	apt install tar bzip2 -y
    if command -v tar &> /dev/null; then
	    tar -xjvf ssh.tar.bz2
    else
	    echo "无法解压"
	    exit 1
    fi
fi
cd dropbear-2025.88
./configure
make && make install