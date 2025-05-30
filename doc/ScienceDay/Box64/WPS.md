建议使用ruyi命令来安装WPS Office。

```bash
ruyi install --host x86_64 wps-office
```

跟随提示安装即可。

```bash
pushd /home/foo/.local/share/ruyi/binaries/x86_64/wps-office-$(version)
sed -i "s@gInstallPath=/@gInstallPath=$(pwd)/@" ./usr/bin/*
popd
```

运行：
```bash
~/.local/share/ruyi/binaries/x86_64/wps-office-$(version)/usr/bin/wps
```

理论上可以直接运行。但是如果有问题，可以首先尝试喜欢个sysroot试试：
```bash
wget https://mirror.iscas.ac.cn/ruyisdk/dist/temp/debian-bookworm.gui.20240705.amd64.tar.zst
sudo mkdir /opt/debian-bookworm.amd64
pushd /opt/debian-bookworm.amd64
tar -xf ~/debian-bookworm.gui.20240705.amd64.tar.zst
popd
```

```bash
export BOX64_LD_LIBRARY_PATH=/opt/debian-bookworm.amd64/usr/lib/x86_64-linux-gnu
```

如果还是有问题，可以直接用box64运行：
```bash
box64 ~/.local/share/ruyi/binaries/x86_64/wps-office-$(version)/usr/lib/office6/wps
```

可以把遇到的log发到box64的issue中。