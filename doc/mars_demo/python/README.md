# Python for Milk-V Mars

## 简介

Milk-V Mars 采用了 jh7110 系列芯片，且 GPIO 与 VisionFive2 兼容。

StarFive 官方仿照树莓派的`RPi.GPIO`，为该芯片组移植了`VisionFive.gpio`。通过改变`import`，可以实现用 Python 操控如 UART、IIC 等硬件，并可使用大部分树莓派的 Python 项目。

## 环境配置

### 安装操作系统

从 Github 获取官方 Debian 镜像：https://github.com/milkv-mars/mars-buildroot-sdk/releases/download/V1.0.6/mars_debian-desktop_sdk-v3.6.1_sdcard_v1.0.6.img.zip

刷写到 sd 卡以安装系统：
```bash
unzip mars_debian-desktop_sdk-v3.6.1_sdcard_v1.0.6.img.zip
sudo dd if=mars_debian-desktop_sdk-v3.6.1_sdcard_v1.0.6.img of=/dev/sdc bs=1M status=progress
```

### 扩展分区

使用 fdisk 扩展根分区：
```bash
sudo fdisk /dev/mmcblk1
```

以下在 fdisk 中：
```bash
d 4 n 4 No w
```

resize fs:
```bash
sudo resize2fs /dev/mmcblk1p4
```

### 安装 Python

使用 apt 安装 Python3 和 pip：
```bash
sudo apt install python3-pip
```

### 安装库

由于 pip 目前不支持在 RISC-V 上直接安装 any whl 库，需要使用以下方法：

在 pypi 上下载 whl 文件。地址：https://pypi.org/project/VisionFive.gpio/#files

以下以 1.3.2 版本为例：
```bash
wget https://files.pythonhosted.org/packages/6b/7c/06f414cd6d97bd63eabf22314e7480ff765dd8005ee2ea89743b35dc1280/VisionFive.gpio-1.3.2-cp310-cp310-any.whl
```

重命名该文件为 riscv64 架构：
```bash
mv VisionFive.gpio-1.3.2-cp310-cp310-any.whl VisionFive.gpio-1.3.2-cp310-cp310-riscv64.whl
```

现在就可以用 pip 安装了：
```bash
pip install VisionFive.gpio-1.3.2-cp310-cp310-riscv64.whl
```

## Demo

### GPIO (Blink)

板子上的 led 接到了 pin 22 上。

```python
import VisionFive.gpio as GPIO
import time

led_pin = 22
GPIO.setup(led_pin, GPIO.OUT)

while True:
    GPIO.output(led_pin, GPIO.HIGH)
    time.sleep(1)
    GPIO.output(led_pin, GPIO.LOW)
    time.sleep(1)
```

### I2C

对应的 I2C pin 可从 dts 中看出。在此使用 I2C 5 进行连接测试，从对端设备接受字符：

| I2C 5 SCL | I2C 5 SDA |
| --------- | --------- |
| 19        | 20        |

```python
import VisionFive.i2c as I2C
import time

addr=0x20

dev="/dev/i2c-5"

I2C.open(dev, addr)

while True:
    data = I2C.read(1)
    print(data)

```

### UART

| TX  | RX  |
| --- | --- |
| 10  | 8   |

```python
import serial
import time

port="/dev/ttyS0"

sr = serial.Serial(port, baudrate=115200, timeout=0.5)

i=0
while True:
    s = f"Hello! {i}\n"
    sr.write(s.encode())
    i+=1
```

### PWM

```python
import VisionFive.gpio as GPIO
import time

led_pin = 22
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(led_pin, GPIO.OUT)
pwm=GPIO.PWM(led_pin, 1000)
pwm.start(0)

while True:
    for duty in range(0, 101):
        pwm.ChangeDutyCycle(duty)
        sleep(0.5)
    sleep(1)
    for duty in range(100, -1, -1):
        pwm.ChangeDutyCycle(duty)
        sleep(0.5)
    sleep(1)
```

### SPI

SPI 采用还回方式测试：

| MOSI | MISO | SCLK |
| ---- | ---- | ---- |
| 52   | 53   | 23   |

```python
import VisionFive.spi as SPI
import VisionFive.gpio as GPIO

dev="/dev/spidev1.0"

SPI.getdev(dev)
SPI.setmode(600000, 0, 8)

i=0
while True:
    s=f"Hello {i}".encode()
    spi.write(s)
    recv = spi.read()

    print(recv.decode())

    sleep(1)
```