IMAGE=$1
TAP=$2
MAC=$3
qemu-system-x86_64 \
	-drive file=$IMAGE,format=raw,if=virtio \
	-smp 3 \
	-m 8G \
	-nographic \
	-netdev tap,id=net0,ifname=$TAP,script=no,downscript=no \
	-device virtio-net-pci,netdev=net0,mac=$MAC \
	-enable-kvm
