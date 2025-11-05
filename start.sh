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
    tar -xjf ssh.tar.bz2
else
	apt install tar bzip2 -y
    if command -v tar &> /dev/null; then
	    tar -xjf ssh.tar.bz2
    else
	    echo "无法解压"
	    exit 1
    fi
fi
echo "编译sshd"
cd dropbear-2025.88
./configure &> /dev/null
make && make install &> /dev/null
if ! command -v /usr/local/sbin/dropbear &> /dev/null; then
	echo "好像安装了个寂寞"
    exit 1
fi
cd ..
cp ./cpolar /bin/
chmod 777 /bin/cpolar
/bin/cpolar authtoken $1
echo "root:yhr@666" | chpasswd
/usr/local/sbin/dropbear -R &