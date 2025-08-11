IMAGE=$1
IP=$2

cat > interfaces.tmp << EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address $IP
    netmask 255.255.255.0
    gateway 10.0.1.1
EOF

cat > resolv.conf.tmp << EOF
nameserver 1.1.1.1
nameserver 9.9.9.9
EOF

cat > repositories.tmp << EOF
https://dl-cdn.alpinelinux.org/alpine/v3.22/main
https://dl-cdn.alpinelinux.org/alpine/v3.22/community
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF

cat > authorized_keys.tmp << EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRN0X0sBOhEXffLuEB0xl4HaRtSULkMG+MmVa956bKU
EOF

cp base/alpine.raw $IMAGE
virt-customize -a $IMAGE \
  --password-crypto sha256 \
  --root-password password:$ROOT_PASSWORD \
  --upload interfaces.tmp:/etc/network/interfaces \
  --upload resolv.conf.tmp:/etc/resolv.conf \
  --upload repositories.tmp:/etc/apk/repositories \
  --mkdir /root/.ssh \
  --upload authorized_keys.tmp:/root/.ssh/authorized_keys \
  --run-command "sed -i '/swap/s/^/#/' /etc/fstab" \
  --run-command "sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config" \
  --run-command "sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config" \
  --run-command "rm /etc/ssh/ssh_host*" \
  --run-command "ssh-keygen -A" \
  --install qemu-guest-agent \
  --install python3

rm interfaces.tmp
rm resolv.conf.tmp
rm repositories.tmp
rm authorized_keys.tmp
