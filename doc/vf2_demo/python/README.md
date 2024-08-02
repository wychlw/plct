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
mv VisionFive.gpio-1.3.2-cp310-cp310-any.whl VisionFive.gpio-1.3.2-cp310-cp310-linux_riscv64.whl
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

**需要注意，在开启中断后，读取该 GPIO 的行为会被接管从而造成错误！**
若您看到：`Failed to issue GPIO_GET_LINE_IOCTL (-22), Invalid argument`，这便是因为读取 GPIO 冲突了。

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

### 外设使用

接下来的一节中，将会给出一些具体的，如何使用某个典型外设的示例。

#### HC-SR04

HC-SR04 是一种超声波测距模块，常用于测量距离。它通过发射超声波并检测其反射来计算物体的距离。其通过 Trig 引脚接收到一个信号后，发射 8 个 40kHz 的超声波脉冲。超声波遇到障碍物后会反射回来，Echo 引脚检测到回波。通过测量超声波发射和接收之间的时间差，可以计算出距离。公式为：

$$
距离 = \frac{时间 \times 声速}{2}
$$

具体而言，其通过向 trig 引脚发送一个 10us 的高电平信号来触发，而后回波时间差由 echo 引脚高电平时长表示。如 echo 引脚拉高 500us，则代表时间差为 500us，带入公式可得距离。

接线如下：

| VCC | Echo | Trig | GND |
| --- | ---- | ---- | --- |
| 1   | 22   | 18   | 9   |

VCC 需要 +5V。

##### 中断方式

我们可以通过检测边沿中断的方式，来获得 echo 引脚被拉高和拉低的时间，从而计算出时间差和距离。

代码如下：
```python
import VisionFive.gpio as GPIO
import time

GPIO.setmode(GPIO.BOARD)

trig_pin = 18
echo_pin = 22

GPIO.setup(trig_pin, GPIO.OUT)
GPIO.setup(echo_pin, GPIO.IN)

# 用于对传播时间计时
start_time = time.time()
end_time = time.time()

# 距离 = 声速 * 时长 / 2
def cal(t):
    return t * 34300 / 2 # 空气中 34300 cm/s

# 回调函数，在收到回声信号时计时
# 其被拉高的时长为距离，故在上升沿触发开始计时，下降沿触发停止计时
def trig(pin_num, edge):
    global start_time
    global end_time
    if edge == GPIO.RISING:
        start_time = time.time()
    else:
        end_time = time.time()
        dist = cal(end_time - start_time)
        print(f"Trigger! Dist is {dist:.4f} cm")

def trig_once():
    # 10us 触发测距
    GPIO.output(trig_pin, GPIO.HIGH)
    time.sleep(0.000001)
    GPIO.output(trig_pin, GPIO.LOW)
    # 触发完毕


# 初始化设置
GPIO.add_event_detect(echo_pin, GPIO.BOTH, trig)
GPIO.output(trig_pin, GPIO.LOW)
time.sleep(0.5)

while True:
    trig_once()
    time.sleep(1)
```

预期会输出：
```log
Trigger! Dist is 1.7582 cm
Trigger! Dist is 2.0608 cm
Trigger! Dist is 10.7701 cm
Trigger! Dist is 18.4204 cm
Trigger! Dist is 28.4831 cm
Trigger! Dist is 23.0122 cm
Trigger! Dist is 16.1143 cm
Trigger! Dist is 9.9605 cm
Trigger! Dist is 5.5772 cm
Trigger! Dist is 7.4949 cm
Trigger! Dist is 16.6049 cm
Trigger! Dist is 67.2212 cm
Trigger! Dist is 77.2798 cm
Trigger! Dist is 18.7925 cm
Trigger! Dist is 16.0529 cm
Trigger! Dist is 16.5804 cm
```

结果展示视频：
[Video](./assets/HC_SR04.mp4)

##### 循环读取方式

当然，我们也可以直接通过循环来不断检测电平变化，得到结果。需要注意由于 GPIO 抢占，两种方式不能同时使用。

代码如下：
```python
import VisionFive.gpio as GPIO
import time

GPIO.setmode(GPIO.BOARD)

trig_pin = 18
echo_pin = 22

GPIO.setup(trig_pin, GPIO.OUT)
GPIO.setup(echo_pin, GPIO.IN)

# 用于对传播时间计时
start_time = time.time()
end_time = time.time()

# 距离 = 声速 * 时长 / 2
def cal(t):
    return t * 34300 / 2 # 空气中 34300 cm/s

def trig_once():
    # 10us 触发测距
    GPIO.output(trig_pin, GPIO.HIGH)
    time.sleep(0.000001)
    GPIO.output(trig_pin, GPIO.LOW)
    # 触发完毕
    # 尝试另一种方式：忙等等到电平变化
    # 我们来比较两种方式计算的差异
    # 此处有变量作用域覆盖，不会改变上面定义的全局变量
    begin_time = time.time()
    end_time = time.time()
    while GPIO.input(echo_pin) == GPIO.LOW:
        begin_time = time.time()
    while GPIO.input(echo_pin) == GPIO.HIGH:
        end_time = time.time()
    dist = cal(end_time - begin_time)
    print(f"Another way! Dist is {dist:4f} cm")

# 初始化设置
GPIO.output(trig_pin, GPIO.LOW)
time.sleep(0.5)

while True:
    trig_once()
    time.sleep(1)
```

结果：
```log
Another way! Dist is 7.470381 cm
Another way! Dist is 7.494915 cm
Another way! Dist is 11.305749 cm
Another way! Dist is 15.120673 cm
Another way! Dist is 15.096140 cm
Another way! Dist is 15.100229 cm
Another way! Dist is 22.770965 cm
Another way! Dist is 24.619138 cm
Another way! Dist is 22.766876 cm
Another way! Dist is 22.721899 cm
Another way! Dist is 26.536822 cm
Another way! Dist is 25.866246 cm
Another way! Dist is 23.008120 cm
Another way! Dist is 11.591971 cm
Another way! Dist is 7.535803 cm
Another way! Dist is -34.808624 cm
```

可以发现，该方式可能会造成较大误差。

#### 蜂鸣器

可以通过控制交变电流，带动振膜发声，从而播放出歌曲。

接线如下：

| VCC | GND |
| --- | --- |
| 18  | 9   |

##### 简易使用

要想只是简单的使用起来蜂鸣器，只需要不断改变 gpio 的电平即可。如下展示了如何播放一段简单的音阶：
```python

import VisionFive.gpio as GPIO
import time
import mido

GPIO.setmode(GPIO.BOARD)

buzz_pin = 18

class Buzz:
    def __init__(self, pin, method = 'loop'):
        self._pin = pin
        self._method = method
        GPIO.setup(self._pin, GPIO.OUT)
        GPIO.output(self._pin, GPIO.HIGH)

    def __del__(self):
        GPIO.cleanup()

    def buzz(self, freq, duration):
        delay = 1.0 / freq
        cycles = int(duration * freq / 2)
        for _ in range(cycles):
            GPIO.output(self._pin, GPIO.LOW)
            time.sleep(delay)
            GPIO.output(self._pin, GPIO.HIGH)
            time.sleep(delay)

class Note:
    def __init__(self, freq, duration):
        self._freq = freq
        self._duration = duration

test_song = [
    Note(440, 1), # A
    Note(523, 1), # C
    Note(587, 1), # D
    Note(659, 1), # E
    Note(698, 1), # F
    Note(784, 1), # G
    Note(880, 1), # A
]

def main():
    buzz = Buzz(buzz_pin)
    for note in test_song:
    if note._freq == 0:
        time.sleep(note._duration)
    else:
        buzz.buzz(note._freq, note._duration)

if __name__ == '__main__':
    main()

```

##### Bad Apple

通过充分使用如 PWM 的功能，我们能放出一首 Bad Apple。以下展示了如何使用 PWM 与无源蜂鸣器结合来进行放送：
```python
import VisionFive.gpio as GPIO
import time
import mido

GPIO.setmode(GPIO.BOARD)

buzz_pin = 18

class Buzz:
    def __init__(self, pin, method = 'loop'):
        self._pin = pin
        self._method = method
        GPIO.setup(self._pin, GPIO.OUT)

        if method == 'pwm':
            self.buzz = self.__buzz_pwm
            self._pwm = GPIO.PWM(self._pin, 440)
            self._pwm.start(50)
        elif method == 'loop':
            self.buzz = self.__buzz_loop
            GPIO.output(self._pin, GPIO.HIGH)
        else:
            raise ValueError('Invalid method')

    def __del__(self):
        GPIO.cleanup()
    
    def __buzz_pwm(self, freq, duration):
        self._pwm.ChangeFrequency(freq)
        time.sleep(duration)
        

    def __buzz_loop(self, freq, duration):
        delay = 1.0 / freq
        cycles = int(duration * freq / 2)
        for _ in range(cycles):
            GPIO.output(self._pin, GPIO.LOW)
            time.sleep(delay)
            GPIO.output(self._pin, GPIO.HIGH)
            time.sleep(delay)
    
    def buzz(self, freq, duration):
        pass

class Note:
    def __init__(self, freq, duration):
        self._freq = freq
        self._duration = duration

class Song:
    def __init__(self, buzz, notes = []):
        self._buzz = buzz
        self._notes = notes

    def play(self):
        for note in self._notes:
            if note._freq == 0:
                time.sleep(note._duration)
            else:
                self._buzz.buzz(note._freq, note._duration)


from tk import *
class Badapple(Song):
    def __init__(self, buzz):
        note = []
        for i in range(1, len(d1), 2):
            note.append(Note(m1[i] * 2, d1[i]/100000))
        super().__init__(buzz, note)

def main():
    # song = Song(Buzz(buzz_pin), test_song)
    song = Badapple(Buzz(buzz_pin, 'pwm'))
    song.play()

if __name__ == '__main__':
    main()

```

由于曲谱较长，其被放在了 [此处](./assets/tk.py)。在使用 PWM 时注意 gpio 被占用的情况。

#### GPS

NEO-6M 是一款通过串口与主机相连的 GPS 模块。其通过使用串口向主机发送一串具有固定格式的字符串来传输当前的 GPS 状态、卫星状态和地理位置等信息。

接线如下：

| VCC | TXD | RXD | GND |
| --- | --- | --- | --- |
| 1   | 10  | 8   | 9   |

波特率为 9600。

在建立连接后，我们会收到一串由 `,` 分割的数据，格式分为两周：GPGSA 和 GPGAA。GPGAA 携带了当前的 GPS 定位信息（如时间、坐标等）；GPGSA 携带了当前的状态信息，如收到的卫星等。具体定义可见下方，信息类别由第一个字段决定。如一段 GPGSA 信息可能如下：
`GPGSA,A,,,,,,,,,,,,,,,,`

代码如下：
```python

import serial
import time

GPGSA_dict = {
"msg_id":  	0,
"mode1":  	1,
"mode2":  	2,
"ch1":          3,
"ch2":          4,
"ch3":          5,
"ch4":          6,
"ch5":          7,
"ch6":          8,
"ch7":          9,
"ch8":          10,
"ch9":          11,
"ch10":         12,
"ch11":         13,
"ch12":         14,
}

GPGGA_dict = {
"msg_id":  		0,
"utc":  		        1,
"latitude":             2,
"NorS":                 3,
"longitude":            4,
"EorW":                 5,
"pos_indi":             6,
"total_Satellite":      7,
}

uart_port = "/dev/ttyS0"

def IsValidGpsinfo(gps): 
    data = gps.readline()
    #Convert the data to string. 
    msg_str = str(data, encoding="utf-8")
    #Split string with ",".
    msg_list = msg_str.split(",")
    
    #Parse the GPGSA message.
    if (msg_list[GPGSA_dict['msg_id']] == "$GPGSA"): 
            print()
            #Check if the positioning is valid.
            if msg_list[GPGSA_dict['mode2']] == "1": 
                print("!!!!!!Positioning is invalid!!!!!!")
            else: 
                print("*****The positioning type is {}D *****".format(msg_list[GPGSA_dict['mode2']]))
                print("The Satellite ID of channel {} : {}")
                #Parse the channel information of the GPGSA message.
                for id in range(0, 12): 
                    key_name = list(GPGSA_dict.keys())[id + 3]
                    value_id =  GPGSA_dict[key_name]
                    if  not (msg_list[value_id] == ''): 
                        print("                           {} : {}".format(key_name, msg_list[value_id]))

    #Parse the GPGGA message. 
    if msg_list[GPGGA_dict['msg_id']] == "$GPGGA": 
        print()
        print("*****The GGA info is as follows: *****")
        for key, value in GPGGA_dict.items(): 
            #Parse the utc information.
            if key == "utc": 
                utc_str =  msg_list[GPGGA_dict[key]]
                if not utc_str == '': 
                    h = int(utc_str[0:2])
                    m = int(utc_str[2:4])
                    s = float(utc_str[4:])
                    print(" utc time: {}:{}:{}".format(h,m,s))
                    print(" {} time: {} (format: hhmmss.sss)".format(key, msg_list[GPGGA_dict[key]]))
            #Parse the latitude information.
            elif key == "latitude": 
                lat_str = msg_list[GPGGA_dict[key]]
                if not lat_str == '': 
                    Len = len(lat_str.split(".")[0])
                    d = int(lat_str[0:Len-2])
                    m = float(lat_str[Len-2:])
                    print(" latitude: {} degree {} minute".format(d, m))
                    print(" {}: {} (format: dddmm.mmmmm)".format(key, msg_list[GPGGA_dict[key]]))
            #Parse the longitude information.
            elif key == "longitude": 
                lon_str = msg_list[GPGGA_dict[key]]
                if not lon_str == '': 
                    Len = len(lon_str.split(".")[0])
                    d = int(lon_str[0:Len-2])
                    m = float(lon_str[Len-2:])
                    print(" longitude: {} degree {} minute".format(d, m))
                    print(" {}: {} (format: dddmm.mmmmm)".format(key, msg_list[GPGGA_dict[key]]))
            else: 
                print(" {}: {}".format(key, msg_list[GPGGA_dict[key]]))

def main(): 
    gps = serial.Serial(uart_port, baudrate=9600, timeout=0.5)
    while True: 
        IsValidGpsinfo(gps)
        time.sleep(1)
                
if __name__ == "__main__": 
    main()
```

预期结果（无卫星信号）：

```log
*****The GGA info is as follows: *****
 msg_id: $GPGGA
 NorS: 
 EorW: 
 pos_indi: 0
 total_Satellite: 00

*****The GGA info is as follows: *****
 msg_id: $GPGGA
 NorS: 
 EorW: 
 pos_indi: 0
 total_Satellite: 00

```