# TinyMaix on M1s Dock

## 简介 

TinyMaix 是一款专为低资源的单片机设计的 AI 神经网络推理框架，通常被称为 TinyML，其由 sipeed 开发，仓库位于：
[sipeed/TinyMaix](https://github.com/sipeed/TinyMaix/)

TinyMaix 支持了 M1s，可以直接在其上面运行 TinyMaix 的模型。

通过几个 API 的调用，可以简单的上 M1s 上运行起预训练好的 AI 模型或使用算子。

## Tiny Maix 使用

要使用 TinyMaix，我们需要以下五个文件：
- tm_model.c
- tm_layers.c
- tinymaix.h
- tm_port.h
- arch_cpu.h

它们都已经被移植完毕了，可以在上面直接使用。

## Demo

### 官方 Demo

官方自己包含了一个使用 mnist 识别数字的 Demo，其可以识别摄像头拍到的数字并显示。位于 `M1s_BL808_example/c906_app/tinymaix_mnist_demo` 下。

以此 demo 展示如何使用该 SDK 进行编写和构建，及如何进行刷写。

#### 构建

构建过程：
```bash
cd M1s_BL808_example/c906_app
./build.sh tinymaix_mnist_demo
```

生成的文件位于 `build_out/tinymaix_mnist_demo.bin`

#### 刷写程序

使用 type-c 线连接 **UART** 口和电脑，按住 BOOT+RST，先放开 RST，再放开 BOOT，进入刷写模式。

回到 bl808 目录下，或许需要根据实际替换各个路径：
```bash
cube/bflb_iot_tool-ubuntu --chipname=bl808 --port=/dev/ttyUSB1 --baudrate=2000000 --firmware="M1s_BL808_example/c906_app/build_out/tinymaix_mnist_demo.bin" --addr 0x101000 --single
```

不要忘了按一下 rst

#### 预期结果

运行结果：
[Video](./assets/1.mp4)