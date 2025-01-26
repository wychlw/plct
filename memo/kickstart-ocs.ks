text
#reboot
lang en_US.UTF-8
keyboard us
# short hostname still allows DHCP to assign domain name
network --bootproto dhcp --device=link --hostname=ocs-riscv
rootpw --plaintext riscv
firewall --enabled --ssh
timezone --utc America/New_York
# selinux --enforcing

bootloader --disabled
#--extlinux
# Halt the system once configuration has finished.
poweroff

repo --name=ocs-riscv --baseurl=http://koji.wcysite.com/kojifiles/repos/ocs-stream_rv64_build/latest/riscv64/

zerombr
clearpart --all --initlabel --disklabel=gpt

part /boot/efi --fstype=vfat --size=128 --label=EFI
part /boot --fstype=ext4 --size=512 --label=boot --asprimary
part / --fstype=ext4 --size=12288 --label=rootfs

%packages
# Sorry but not all packages in core can be installed for now...
#@core
# Manually expand group core
audit
basesystem
bash
coreutils
curl
dhcp-client
dnf
e2fsprogs
filesystem
glibc
hostname
iproute
iputils
kbd
less
man-db
ncurses
openssh-clients
openssh-server
parted
policycoreutils
procps-ng
rootfiles
rpm
selinux-policy-targeted
setup
shadow-utils
sssd-common
sssd-kcm
sudo
systemd
util-linux
vim-minimal
yum

# These packages don't exists, remove them...
-lsvpd
-powerpc-utils
-dnf5
-zram-generator-defaults
-dnf5-plugins
-s390utils-base
-NetworkManager

# Why passwd isn't provided by shadow?
passwd

# Use microdnf... Yeah
microdnf
-@standard
-initial-setup-gui
-generic-release*
-glibc-all-langpacks

# hardware-support not existes yet... ignoring all of them
#@hardware-support
# Intel wireless firmware assumed never of use for disk images
#-iwl*
#-ipw*
#-usb_modeswitch

kernel
# the kernel toplevel package pulls in kernel-core and kernel-modules.
kernel-core
kernel-modules
#linux-firmware

# Remove this in %post
#dracut-config-generic
#-dracut-config-rescue
# Lets resize / on first boot
#dracut-modules-growroot
#chrony

# riscv64 is using extlinux.conf
extlinux-bootloader
# grub2-common would fail to run... Delete them
-grub2-efi-riscv64
-grub2-tools
-grub2-common
# riscv64 may use FIT image
uboot-tools

# No longer in @core since 2018-10, but needed for livesys script
initscripts
chkconfig

# temp
#initial-setup

glibc-langpack-en
# make sure all the locales are available for inital-setup and anaconda to work
#glibc-all-langpacks

# recommended by iproute, we don't want it in minimal
-iproute-tc
# recommended by gnutls, we don't want it in minimal
-trousers

# Allow qemu to do more things
qemu-guest-agent

%end

%post
# Find the architecture we are on
arch=$(uname -m)

echo "Packages within this disk image"
rpm -qa --qf '%{size}\t%{name}-%{version}-%{release}.%{arch}\n' |sort -rn

# remove random seed, the newly installed instance should make it's own
rm -f /var/lib/systemd/random-seed

dnf -y remove dracut-config-generic

# Remove machine-id on pre generated images
rm -f /etc/machine-id
touch /etc/machine-id

# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

#Disable existed repo files
mkdir -p /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo  /etc/yum.repos.d/backup/

# Create OpenCloudOS RISC-V Koji repo
cat << EOF > /etc/yum.repos.d/ocs-riscv-koji.repo
[ocs-riscv-koji]
name=OpenCloudOS RISC-V Koji
baseurl=http://koji.wcysite.com/kojifiles/repos/ocs-stream_rv64_build/latest/riscv64/
enabled=1
gpgcheck=0
EOF

# setup login account
echo -e "plctlab" | passwd riscv
usermod -a -G wheel riscv

# setup login message
cat << EOF | tee /etc/issue /etc/issue.net
Welcome to the OCS/RISC-V disk image

Build date: $(date --utc)

Kernel \r on an \m (\l)

The root password is 'riscv'.
root password logins are disabled in SSH.
User 'riscv' with password 'plctlab' in 'wheel'  groups
is provided.

To install new packages use 'dnf install ...'

To upgrade disk image use 'dnf upgrade --best'

If DNS isn’t working, try editing ‘/etc/yum.repos.d/ocs-riscv-koji.repo’.

OCS/RISC-V
-------------
Koji OCS v0.0.1-a
EOF

# systemd on no-SMP boots (i.e. single core) sometimes timeout waiting for storage
# devices. After entering emergency prompt all disk are mounted.
# For more information see:
# https://www.suse.com/support/kb/doc/?id=7018491
# https://www.freedesktop.org/software/systemd/man/systemd.mount.html
# https://github.com/systemd/systemd/issues/3446
# We modify /etc/fstab to give more time for device detection (the problematic part)
# and mounting processes. This should help on systems where boot takes longer.
sed -i 's|noatime|noatime,x-systemd.device-timeout=300s,x-systemd.mount-timeout=300s|g' /etc/fstab

# systemd starts serial consoles on /dev/ttyS0 and /dev/hvc0.  The
# only problem is they are the same serial console.  Mask one.
systemctl mask serial-getty@hvc0.service

# setup systemd to boot to the right runlevel
echo -n "Setting default runlevel to multiuser text mode"
systemctl set-default multi-user.target
echo .

%end

# EOF
