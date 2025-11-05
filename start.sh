#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "权限不足 $(id -u)"
    exit 1
fi
apt update -y
apt install build-essential -y

if command -v make &> /dev/null; then
    echo "make 版本：$(make --version | head -n1)"
else
    exit 1
fi

