#!/bin/bash



PUBKEY_FILE="./id_unified.pub"
ROOT_SSH="/root/.ssh"
SSHD_CFG="/etc/ssh/sshd_config"


if [ "$(id -u)" -ne 0 ]; then
    exec sudo bash "$0" "$@"
fi

apt-get update -y
apt-get upgrade -y

mkdir -p "$ROOT_SSH"
chmod 700 "$ROOT_SSH"
PUB_CONTENT=$(cat "$PUBKEY_FILE")
echo "$PUB_CONTENT" >> "$ROOT_SSH/authorized_keys"
chmod 600 "$ROOT_SSH/authorized_keys"
chown root:root "$ROOT_SSH/authorized_keys"

sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' "$SSHD_CFG"
sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' "$SSHD_CFG"

sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$SSHD_CFG"
sed -i 's/^#PasswordAuthentication no/PasswordAuthentication no/' "$SSHD_CFG"

sed -i "s/^PermitRootLogin.*/PermitRootLogin yes/" "$SSHD_CFG"

sed -i 's/^PermitEmptyPasswords yes/PermitEmptyPasswords no/' "$SSHD_CFG"
sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords no/' "$SSHD_CFG"

sshd -t

cp ./cpolar /bin/
chmod 777 /bin/cpolar
/bin/cpolar authtoken $1

systemctl enable --now ssh
systemctl restart ssh
