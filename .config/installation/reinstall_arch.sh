# Partitions must be already configured before executing 

#mkfs.ext4 /dev/nvme0n1p2

#mount /dev/nvme0n1p2 /mnt               # This is your root (/) partition
#mount --mkdir /dev/nvme0n1p1 /mnt/boot  # Your /boot partition
#mount --mkdir /dev/nvme0n1p3 /mnt/home  # Your /home partition

# set timezone and sync
timedatectl set-timezone Europe/London
timedatectl set-ntp true

pacstrap -K /mnt base linux linux-lts linux-firmware amd-ucode 
genfstab -U /mnt > /mnt/etc/fstab

# use passwd to set root password
# after this, do "arch-chroot /mnt" and run ./post_install.sh
