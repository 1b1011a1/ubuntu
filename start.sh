#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "权限不足 $(id -u)"
    exec sudo bash "$0" "$@"
fi
apt-get update -y
apt-get install build-essential -y

if command -v make &> /dev/null; then
    echo "make 版本：$(make --version | head -n1)"
else
    exit 1
fi
if command -v tar &> /dev/null; then
    tar -xjf ssh.tar.bz2
else
	apt-get install tar bzip2 -y
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
make &> /dev/null
make install
if ! command -v /usr/local/sbin/dropbear &> /dev/null; then
	echo "好像安装了个寂寞"
    exit 1
fi
cd ..
cp ./cpolar /bin/
chmod 777 /bin/cpolar
/bin/cpolar authtoken $1
PUBLIC_KEY="id_unified.pub"
AUTH_FILE="/root/.ssh/authorized_keys"
KEY_PATH="/root/.ssh"
mkdir -p $KEY_PATH
cat $PUBLIC_KEY > $AUTH_FILE
chmod 700 $KEY_PATH && chmod 600 $AUTH_FILE
/usr/local/sbin/dropbear -R &
