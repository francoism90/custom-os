# Installer Requirements for CustomOS

## Btrfs Subvolume Layout

The installer must create the following btrfs subvolume structure before deploying the image:

```bash
# Mount the btrfs root
mount -o subvolid=5 /dev/sdX /mnt

# Create subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@log

# Mount root subvolume
umount /mnt
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@ /dev/sdX /mnt

# Create mount points
mkdir -p /mnt/{home,root,srv,var/cache,var/tmp,var/log}

# Mount other subvolumes
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@home /dev/sdX /mnt/home
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@root /dev/sdX /mnt/root
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@srv /dev/sdX /mnt/srv
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@cache /dev/sdX /mnt/var/cache
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@tmp /dev/sdX /mnt/var/tmp
mount -o defaults,noatime,compress=zstd,space_cache=v2,subvol=/@log /dev/sdX /mnt/var/log

# Deploy image to /mnt
# (extract/rsync the image contents into the mounted subvolumes)

# Install bootloader
# (systemd-boot to ESP)
```

## Partition Layout

- ESP (EFI System Partition): FAT32, labeled "ESP", mounted at /efi or /boot/efi
- Root: btrfs, labeled "root-x86-64", contains subvolumes

## Notes

- The fstab is pre-configured in the image at `/etc/fstab`
- systemd-gpt-auto-generator will auto-mount the ESP
- Updates via systemd-sysupdate will deploy to `/@` without recreating subvolumes
