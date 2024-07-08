# Satrdew Valley on VisionFive2

## 简介

通过使用 GLES 和 Box64，我们能在 VisionFive2 上玩星露谷物语。

## 硬件准备

- 一块 VisionFive2 开发板及电源线
- HDMI 显示器和连接线（用于展示图形界面）
- 键鼠
- SD 卡

## 环境配置

### gl4es

gl4es 被用于提供 opengl 图形 API：

安装 gl4es:

```bash
git clone https://github.com/ptitSeb/gl4es
cd gl4es
mkdir build; cd build; cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo;
make -j4
sudo make install
```

### box64

由于其原生平台是 x86，需要将其转译到 riscv 上运行。通过 box64 来进行这点：

```bash
git clone https://github.com/ptitSeb/box64
cd box64
mkdir build; cd build; cmake .. -D RV64=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo
make -j4  
sudo make install

sudo systemctl restart systemd-binfmt
```

### Satrdew Valley

理论上 Steam 版本的也可以，但是 GOG 的是 DRM Free 的。

下载安装脚本并使用 box64 运行：
```bash
chmod +x Downloads/stardew_valley.sh
 BOX64_BASH=path/to/box64/tests/bash box64 stardew_valley.sh
```

## 运行游戏

```bash
LD_LIBRARY_PATH=path/to/gl4es/lib/:$LD_LIBRARY_PATH box64 Stardew\ Valley
```