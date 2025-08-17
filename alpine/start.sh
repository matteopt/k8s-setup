IMAGE=$1
TAP=$2
MAC=$3
qemu-system-x86_64 \
	-drive file=$IMAGE,format=raw,if=virtio \
	-cpu host \
	-machine type=q35 \
	-smp 3 \
	-m 56G \
	-nographic \
	-netdev tap,id=net0,ifname=$TAP,script=no,downscript=no \
	-device virtio-net-pci,netdev=net0,mac=$MAC \
	-enable-kvm
