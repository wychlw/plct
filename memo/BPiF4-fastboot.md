
Need to download the zip file without the `.img` part.

# Fastboot Command

```bash
fastboot flash gpt partition_universal.json
fastboot flash bootinfo bootinfo_sd.bin
fastboot flash fsbl FSBL.bin
fastboot flash env env.bin
fastboot flash opensbi fw_dynamic.itb
fastboot flash uboot u-boot.itb
fastboot flash bootfs bootfs.ext4
fastboot flash rootfs rootfs.ext4
```

