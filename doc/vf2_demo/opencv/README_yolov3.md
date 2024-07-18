# 在 VisionFive2 上采用 Yolo-V3 进行物体识别

## 简介

VisionFive2 拥有 OpenCV 的 GPU 支持，可以在上面运行使用 GPU 的各类机器学习模型。

YOLO-V3 是一个可被用于各类物体检测的视觉 AI 模型，可以通过使用其 demo 体现如何在 VisionFive2 上使用 Pytorch 进行模型的开发和使用。

该 demo 可展示如何在开发板上如何使用 GPU 加速运行采用 Pytorch 预训练的 AI 模型。

## 硬件准备

- VisonFive2 及相应的电源线
- 屏幕及相应的 HDMI 线
- 摄像头（CSI 或 USB，或任何可被 OpenCV 认出的实体或虚拟的均可）
- 键鼠

## 软件准备



### 安装各类依赖

需要注意，其中的如 libcamera、opencv、cogl 等需要使用 starfive 的定制版本。此文档上传时采用的是 v0.13.0 发行版本，可以在 https://github.com/starfive-tech/Debian/releases/ 处自行查看到最新版本。

首先安装使用 apt 的依赖：
```bash
sudo apt install libv4l-0 libv4l-dev v4l-utils libjpeg-dev libdrm-dev fonts-mathjax libjs-mathjax libpython3.11-minimal libpython3.11-stdlib python3-numpy python3.11 python3.11-minimal python3-h5py libvtk9.1 libqt5test5 libqt5opengl5 libtesseract5 libgdcm-dev libgdal-dev gstreamer1.0-clutter-3.0 gir1.2-clutter-1.0 -y

```

接下来安装 libcamera，地址位于：
```bashyolo-v5
cd ~
wget https://github.com/starfive-tech/Debian/releases/download/v0.13.0-engineering-release-wayland/libcamera-deb.tar.gz
tar -xvzf libcamera-deb.tar.gz
cd libcamera-deb
sudo dpkg --force-all -i *.deb
```

和其带的 apps：
```bash
cd ~
wget https://github.com/starfive-tech/Debian/releases/download/v0.13.0-engineering-release-wayland/libcamera-apps-deb.tar.gz
tar -xvzf libcamera-apps-deb.tar.gz
cd libcamera-apps-deb
sudo dpkg --force-all -i *.deb
```

接下来是 clutter
```bash
cd ~
wget https://github.com/starfive-tech/Debian/releases/download/v0.13.0-engineering-release-wayland/clutter-gst-deb.tar.gz
tar -xvzf clutter-gst-deb.tar.gz
cd clutter-gst-deb
dpkg --force-all -i *.deb
```

cogl：
```bash
cd ~
wget https://github.com/starfive-tech/Debian/releases/download/v0.13.0-engineering-release-wayland/cogl-deb.tar.gz
tar -xvzf cogl-deb.tar.gz
cd cogl-deb
dpkg --force-all -i *.deb
```

最后我们安装 opencv：
```bash
cd ~
wget https://github.com/starfive-tech/Debian/releases/download/v0.13.0-engineering-release-wayland/opencv-deb.tar.gz
tar -xvzf opencv-deb.tar.gz
cd opencv-deb
dpkg --force-all -i *.deb
```

以上包 wget 的地址均为 v0.13.0 版本的，请根据您的实际来切换版本。

然后进行一些清理：
```bash
cd ~
rm -rf libcamera-deb.tar.gz
rm -rf libcamera-apps-deb.tar.gz
rm -rf opencv-deb.tar.gz
rm -rf clutter-gst-deb.tar.gz
rm -rf cogl-deb.tar.gz
rm -rf libcamera-deb
rm -rf libcamera-apps-deb
rm -rf opencv-deb
rm -rf clutter-gst-deb
rm -rf cogl-deb
```

### 若使用 IMX219-CSI 摄像头

需要运行以下代码：
```bash
export PATH=$PATH:/opt/
/opt/media-ctl-pipeline.sh -d /dev/media0 -i csiphy0 -s ISP0 -a start
/opt/ISP/stf_isp_ctrl -m imx219mipi -j 0 -a 1
```

### 拷贝示例 YOLO-V3

我们可以采用一个示例的 VOLO-V3 来进行运行，其采用 pythrch 预训练，并转换为了 onnx：
```bash
cp -r /usr/share/opencv4/yolo-v3
cd ./yolo-v3
python3 ./yolov3.py --device {your-device}
```

其中，your-device 为你的视频输入流编号，如 `4` 代表 `/dev/video4`

## 运行预期结果

应能看到桌面上出现 opencv 的视频流，内含 YOLO-V3 模型的识别结果。

![Video](./videos/yolov3.mp4)
