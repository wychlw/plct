# 边缘检测 on M1s Dock

## 简介

M1s 的 SDK 中带有了处理图像和控制自带显示器的 API，用于处理从开发版自带的摄像头中派出的图像，并输出到显示屏中。其位于 `sipeed/m1s_tools/inc/imgtool` 和 `bl808_spi` 下。

可以通过这两个库，来对摄像头拍摄的图像读取、进行边缘检测后，画到显示屏下。

## 搭建开发环境

以下刷写方案均基于 UART 自动刷写完成。该方式局限性较小，且在 Linux/Windows 通用。

对于其它的刷写方案，详见 [Sipeed Wiki](https://wiki.sipeed.com/hardware/zh/maix/m1s/other/start.html#%E7%83%A7%E5%BD%95%E6%96%B9%E6%B3%95)，需注意其中如 U 盘方式在 Linux 上可能不可使用。

### 获取 SDK

创建 SDK 工作区：
```bash
mkdir -p bl808
cd bl808
git clone https://github.com/sipeed/M1s_BL808_SDK.git
git clone https://github.com/sipeed/M1s_BL808_example.git
cd M1s_BL808_example
ln -s ../M1s_BL808_SDK ./
cd ..
```

请注意 example 为必须获取的，其中含有固件代码。

获取 SDK，需在 [Sipeed](https://dl.sipeed.com/shareURL/others/toolchain) 处手动下载，而后进行如下操作：
```bash
mkdir -p M1s_BL808_SDK/toolchain
tar -zxvf path/to/Xuantie-900-gcc-elf-newlib-x86_64-V2.2.4-20220715.tar.gz -C M1s_BL808_SDK/toolchain/
cd M1s_BL808_SDK/toolchain
mv Xuantie-900-gcc-elf-newlib-x86_64-V2.2.4/ Linux_x86_64
cd ../..
export BL_SDK_PATH=$(pwd)/M1s_BL808_SDK
# persist it: 
# echo "export BL_SDK_PATH=$(pwd)/M1s_BL808_SDK" >> ~/.bashrc
# source ~/.bashrc
```

### 编译固件

由于 Sipeed 不再提供最新版固件，我们必须手动编译固件来进行使用。
假定现在在之前创建的 bl808 目录下：
```bash
cd M1s_BL808_example/e907_app/
./build.sh firmware
```

固件编译在 `build_out/firmware.bin` 处。

### 获取烧写程序

获取 UART 烧写程序，其中包含命令行与图形界面。同时在此步还会获取如分区表、另一部分 M1s Dock 的固件。

同样，假定我们目前在 `bl808` 目录下：
```bash
wget https://dl.sipeed.com/fileList/MAIX/M1s/M1s_Dock/7_Firmware/partition/partition_cfg_16M_m1sdock.toml
wget https://dev.bouffalolab.com/media/upload/download/BouffaloLabDevCube-v1.9.0.zip
mkdir cube
unzip BouffaloLabDevCube-v1.9.0.zip -d cube
chmod +x cube/bflb_iot_tool-ubuntu cube/BLDevCube-ubuntu
```

其中，`cube/bflb_iot_tool-ubuntu` 是 Linux 下命令行烧录程序，`cube/BLDevCube-ubuntu` 是图形界面的。其余系统同理。

### 刷写固件

使用 type-c 线连接 **UART** 口和电脑，按住 BOOT+RST，先放开 RST，再放开 BOOT，进入刷写模式。

回到 bl808 目录下，或许需要根据实际替换各个路径：
```bash
cube/bflb_iot_tool-ubuntu --chipname=bl808 --port=/dev/ttyUSB1 --baudrate=2000000 --boot2="cube/chips/bl808/builtin_imgs/boot2_isp_bl808_v6.6.1/boot2_isp_debug.bin" --pt="partition_cfg_16M_m1sdock.toml" --firmware="M1s_BL808_example/e907_app/build_out/firmware.bin" --d0fw="M1s_BL808_example/c906_app/build_out/d0fw.bin"
```

## Demo

Demo 代码位于`M1s_BL808_example/c906_app/image_processing_demo` 下。以此 demo 展示如何使用该 SDK 进行编写和构建，及如何进行刷写。

#### 构建

构建过程：
```bash
cd M1s_BL808_example/c906_app
./build.sh image_processing_demo
```

生成的文件位于 `build_out/image_processing_demo.bin`

#### 刷写程序

使用 type-c 线连接 **UART** 口和电脑，按住 BOOT+RST，先放开 RST，再放开 BOOT，进入刷写模式。

回到 bl808 目录下，或许需要根据实际替换各个路径：
```bash
cube/bflb_iot_tool-ubuntu --chipname=bl808 --port=/dev/ttyUSB1 --baudrate=2000000 --firmware="M1s_BL808_example/c906_app/build_out/image_processing_demo.bin" --addr 0x101000 --single
```

不要忘了按一下 rst

#### 预期结果

编译过程见命令行录制：

运行结果：
[Video](./1.mp4)