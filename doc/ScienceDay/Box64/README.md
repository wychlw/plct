## 编译

```bash
git clone https://github.com/ptitSeb/box64
cd box64
mkdir build
cd build
cmake .. -D RV64=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
sudo make install
sudo systemctl restart systemd-binfmt
```

## 使用

直接使用`box64` 命令运行 64 位 x86 程序。