# Python for VisionFive2

## 简介

VisionFive2 采用了 jh7110 系列芯片，且 GPIO 与 VisionFive2 兼容。

StarFive 官方仿照树莓派的`RPi.GPIO`，为该芯片组移植了`VisionFive.gpio`。通过改变`import`，可以实现用 Python 操控如 UART、IIC 等硬件，并可使用大部分树莓派的 Python 项目。

## 环境配置

### 安装操作系统

获取官方 Debian 镜像：https://debian.starfivetech.com/

刷写到 sd 卡以安装系统：
```bash
sudo dd if=path/to/debian.img of=/dev/sdc bs=1M status=progress
```

用户名：`user`
密码：`starfive`

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

请注意由于需要操作外设，以下 Demo 都需要 root 权限或自行设置 udev 权限。

### GPIO Basic

Visionfive 2 的基本 GPIO 操作如下：
- `GPIO.setmode(mode)`
    - mode: 
        - `GPIO.BOARD`：pin 编号按照 Visionfive 2 的板级定义给出（即 GPIO PIN 顺序）
        - `GPIO.BCM`：pin 编号按照 JH7110 的芯片定义给出
    - 需要在开始时初始化，一般建议 BOARD 模式
    - **下文中所有 Demo，默认为 BOARD 模式**
- `GPIO.setup(pin_num, mode, pull ?= GPIO.PUD_OFF, init ?= GPIO.LOW)`
    - pin_num: GPIO pin num
    - mode：输入/输出模式
        - GPIO.IN：输入
        - GPIO.OUT：输出
    - pull：上拉/下拉/推挽输出
        - GPIO.PUD_UP：上拉输入
        - GPIO.PUD_DOWN：下拉输入
        - GPIO.PUD_OFF：无上拉/下拉，推挽输出 **Visionfive 2 只支持推挽输出**
    - init：初始值
        - GPIO.HIGH：高输出
        - GPIO.LOW：低输出
    - 初始化某个 GPIO PIN
- `GPIO.gpio_function(pin_num?)`
    - pin_num：可选，GPIO 编号
    - 输出某个 GPIO 支持的功能。若不填写编号则输出全部。
- `GPIO.input(pin_num)`
    - pin_num：GPIO 编号
    - 读取某个 GPIO 的电平
- `GPIO.output(pin_num, level)`
    - pin_num：GPIO 编号
    - level：电平
        - GPIO.HIGH：高输出
        - GPIO.LOW：低输出
    - 设置某个 GPIO 的输出电平

#### 环回测试

将 Pin 22 与 Pin 18 相连，Pin 22 输出，Pin 18 读取电平：

```python
import VisionFive.gpio as GPIO
import time

out_pin = 22
in_pin = 18
GPIO.setmode(GPIO.BOARD)
GPIO.setup(out_pin, GPIO.OUT)
GPIO.setup(in_pin, GPIO.IN)

while True:
    GPIO.output(out_pin, GPIO.HIGH)
    time.sleep(0.5)
    print(GPIO.input(in_pin))
    time.sleep(0.5)
    GPIO.output(out_pin, GPIO.LOW)
    time.sleep(0.5)
    print(GPIO.input(in_pin))
    time.sleep(0.5)
```

预期输出：
```log
user@starfive:~$ sudo python3 ./test.py 
[sudo] password for user: 
1
0
1
0
1
0
1
0
1
0
1
0
```

也可见：[GPIO.cast](./GPIO.cast)

#### Blink

**请注意 LED 电平，否则会烧掉**

使用 Pin 22 作为输出，控制 LED 亮灭：
```python
import VisionFive.gpio as GPIO
import time

led_pin = 22
GPIO.setmode(GPIO.BOARD)
GPIO.setup(led_pin, GPIO.OUT)

while True:
    GPIO.output(led_pin, GPIO.HIGH)
    print(f"Pin: {led_pin}")
    time.sleep(0.5)
    GPIO.output(led_pin, GPIO.LOW)
    print(f"pIN: {led_pin}")
    time.sleep(0.5)
```

能看到 LED 闪烁。

[Video](./assets/LED_BLINK.mp4)

### GPIO Advanced

接下来介绍与 GPIO 中断、回调有关的内容。

- `GPIO.add_event_detect(pin_num, edge, callback?, bouncetime?)`
    - pin_num：GPIO 编号
    - edge：边沿
        - GPIO.RISING：上升沿检测
        - GPIO.FALLING：下降沿检测
        - GPIO.BOTH：两者都
    - callback：回调函数，可选
        - 函数定义：`def func(pin_num, edge)`
    - bouncetime：消抖时间（毫秒），可选
    - 设置启用 GPIO 边沿中断
- `GPIO.add_event_callback(pin_num, callback)`
    - pin_num：GPIO 编号
    - callback：回调函数，可选
        - 函数定义：`def func(pin_num, edge)`
    - 增加回调函数
- `GPIO.detect(pin_num)`
    - pin_num：GPIO 编号
    - 自回调中断设置以来，是否被触发
- `GPIO.get_detected_event(pin_num)`
    - pin_num：GPIO 编号
    - 被设置的中断边沿
- `GPIO.remove_event_detect(pin_num)`
    - pin_num：GPIO 编号
    - 关闭中断，取消所有事件

#### 按键控制

采用按键控制 LED 的状态。
Pin 22 作为 LED 的输出，Pin 18 作为按钮的输入：

```python
import VisionFive.gpio as GPIO
import time

out_pin = 22
in_pin = 18
GPIO.setmode(GPIO.BOARD)
GPIO.setup(out_pin, GPIO.OUT)
GPIO.setup(in_pin, GPIO.IN, GPIO.PUD_DOWN)

led_state = 0

def cb(*args, **kwargs):
    global led_state
    led_state = not led_state
    GPIO.output(out_pin, led_state)
    print(f"LED SWITCHED!")

GPIO.add_event_detect(in_pin, GPIO.RISING, callback = cb, bouncetime = 50)

while True:
    if GPIO.event_detected(in_pin):
        print("Detected Edge!!!")
        print(f"Edge:{GPIO.get_detected_event(in_pin)}")
    time.sleep(0.3)

```

### PWM

Visionfive 2 的 PWM 模块如下：
- `GPIO.PWM(PIN, freq)`
    - PIN: GPIO PIN（见文档）; frep: > 1.0，周期长度（Hz）
    - 定义引脚的 PWM 功能
- `ChangeDutyCycle(duty_cycle)` / `ChangeDutyRatio(duty_cycle)` *alias*
    - dupy_cycle: 0.0 - 100.0，占空比
    - 更改 PWM 波形占空比
- `ChangeFrequency(freq)` / `ChangeFreq(freq)` *alias*
    - freq: > 1.0，周期长度（Hz）
    - 更改 PWM 波形周期
- `start(duty_cycle)`
    - dupy_cycle: 0.0 - 100.0，占空比
    - 启动 PWM 输出
- `stop()`
    - 关闭 PWM 输出

#### PWM LED 亮度

在 pin22 上接一个 LED，能看到其亮度变化：

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
    pwm.ChangeDutyCycle(50)
    for freq in range(5, 50, 5):
        pwm.ChangeFrequency(freq)
        print(f"Freq: {freq}Hz")
        time.sleep(5 * (1 / freq))
    pwm.ChangeFrequency(100)
    for duty in range(0, 51, 5):
        pwm.ChangeDutyCycle(duty)
        print(f"Duty: {duty}%")
        time.sleep(0.3)
    time.sleep(0.5)
    for duty in range(50, -1, -5):
        pwm.ChangeDutyCycle(duty)
        print(f"Duty: {duty}%")
        time.sleep(0.3)
    time.sleep(0.5)
```

第一阶段，LED 越闪越快；第二阶段，LED 先变亮后变暗。能在命令行中看到对应的参数变化。

[Video](./assets/PWM_LED.mp4)

### I2C

对应的 I2C pin 可从 dts 中看出。在此使用 I2C 5 进行连接测试，从对端设备接受字符：

| I2C 5 SCL | I2C 5 SDA |
| --------- | --------- |
| 19        | 20        |

由于 VisionFive.gpio 库不提供 slave 模式，我们可以尝试读取内部连接到该 i2c 总线上的设备，总线为 i2c-5，地址为 0x50，寄存器为 0x2a~0x40：

```python
import VisionFive.i2c as I2C
import time

addr=0x50

dev="/dev/i2c-5"

I2C.open(dev, addr)

for i in range(0x2a, 0x41):
    I2C.write([i])
    data = I2C.read(1)
    print(chr(data[0]), end='')
print()

```

预期输出：
```log
StarFive Technology Co.
```

### UART

使用 UART 功能需要安装 pyserial 模块：
```bash
sudo pip install pyserial
```

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
    sr.flush()
    time.sleep(1)
    i+=1
```

直接电脑上使用 TTL2USB 打开该串口即可。

预期输出：
```log
Hello! 0
                         Hello! 1
                                 Hello! 2
                                         Hello! 3
                                                 Hello! 4
                                                         Hello! 5
                                                                 Hello! 6
                                                                         Hello! 7
                                                                                 Hello! 8
                                                                                         Hello! 9
```

### SPI

SPI 采用环回方式测试：

| MOSI | MISO | SCLK |
| ---- | ---- | ---- |
| 19   | 21   | 23   |

```python

import VisionFive.spi as SPI
import time

dev="/dev/spidev1.0"

SPI.getdev(dev)
SPI.setmode(600000, 0, 8)

i=0
while True:
    s=f"Hello {i}"
    arr=[ord(ch) for ch in s]
    SPI.write(arr)
    recv = SPI.read(len(s))
    print(recv)
    time.sleep(0.5)

```