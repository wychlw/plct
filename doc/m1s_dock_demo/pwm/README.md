# PWM on M1s Dock

## 简介

M1s 中，对于 WIFI、PWM、USB、音频、FLASH 的配置均通过 xram 进行。通过使用 `m1s_c906_xram_*.h` 这类头文件，可以对这些外设进行管理。

## PWM 使用

在 `m1s_c906_xram_pwm.h`中包含了使用 PWM 功能的所有 API，使用如下：

```c
int m1s_xram_pwm_init(int port, int pin, int freq, int duty);
```
- 初始化某个引脚的 PWM 功能，并设置频率和占空比。

```c
int m1s_xram_pwm_deinit(int port);
```
- 关闭 PWM 功能

```c
int m1s_xram_pwm_start(int port, int pin);
```
- 启用 PWM 的输出，在调用前 pin 不会输出任何信息

```c
int m1s_xram_pwm_stop(int port, int pin);
```
- 停止 PWM 的波形输出。需要注意这并没有关闭 PWM 功能，只是暂停了输出。

```c
int m1s_xram_pwm_set_duty(int port, int pin, int freq, int duty);
```
- 在运行时设置某个 pin 的频率和占空比。需要注意初始化后方可使用。

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

Demo 源码如下：
```c
#include <stdbool.h>
#include <stdio.h>

/* FreeRTOS */
#include <FreeRTOS.h>
#include <task.h>

#include "m1s_c906_xram_pwm.h"

#define PWM_PORT (0)
#define PWM_PIN (8)

void main()
{
    m1s_xram_pwm_init(PWM_PORT, PWM_PIN, 2000, 50);
    m1s_xram_pwm_start(PWM_PORT, PWM_PIN);

    uint8_t duty = 50;
    for (int i = 0; i < 10; i++) {
        duty = (duty >= 100) ? 0 : (duty + 10);
        m1s_xram_pwm_set_duty(PWM_PORT, PWM_PIN, 2000, duty);
        vTaskDelay(1000);
    }

    uint32_t freq = 0;
    for (int i = 0; i < 10; i++) {
        freq = freq >= 1 * 1000 * 1000 ? 0 : freq + 1 * 1000 * 100;
        m1s_xram_pwm_deinit(PWM_PORT);
        m1s_xram_pwm_init(PWM_PORT, PWM_PIN, freq, 50);
        m1s_xram_pwm_start(PWM_PORT, PWM_PIN);
        vTaskDelay(1000);
    }

    for (int i = 0; i < 2; i++) {
        m1s_xram_pwm_stop(PWM_PORT, PWM_PIN);
        vTaskDelay(1000);
        m1s_xram_pwm_start(PWM_PORT, PWM_PIN);
        vTaskDelay(1000);
    }
}
```


以下对于新工程如何配置：

### 编译命令及 Makefile



M1s Dock 工程一般具有如下结构：
```text
projects
 |
 |-- Makefile # 全部的 Makefile
 |
 |-- proj_config.mk # 该开发板的配置文件
 |
 |-- proj1 # 具体的 Project
 |      |
        |-- bouffalo.mk # 具体 Project 的 Make 配置，一般可以为空
```

**需要特别注意，Makefile 和 proj_config.mk 在你具体工程的上级目录！**

Makefile 如下：
```makefile
PROJECT_NAME ?= proj_name
PROJECT_PATH = $(abspath .)
PROJECT_BOARD := evb
export PROJECT_PATH PROJECT_BOARD

-include ./proj_config.mk

ifeq ($(origin BL_SDK_PATH), undefined)
$(error   BL_SDK_PATH not found, please enter: export BL_SDK_PATH={sdk_path})
endif

INCLUDE_COMPONENTS += bl808_c906_freertos bl808 bl808_std newlibc hosal freetype yloop cli utils
INCLUDE_COMPONENTS += blai_nn blai_npu_encoder
INCLUDE_COMPONENTS += bl_mm venc_device venc_framework 
INCLUDE_COMPONENTS += freertos_posix
INCLUDE_COMPONENTS += blog
INCLUDE_COMPONENTS += vfs lvgl lwip
INCLUDE_COMPONENTS += blfdt romfs fatfs sdh_helper 
INCLUDE_COMPONENTS += bl808_ring bl808_xram bl_os_adapter
INCLUDE_COMPONENTS += dsp2 bl_mm venc_device venc_framework dsp2_cli_demo mjpeg_sender_bl808 sensor rtsp_server

COMPONENTS_SIPEEED :=
COMPONENTS_SIPEEED += m1s_start
COMPONENTS_SIPEEED += m1s_model_runner
COMPONENTS_SIPEEED += m1s_tools
COMPONENTS_SIPEEED += lfs m1s_lfs_c906
COMPONENTS_SIPEEED += m1s_common_xram m1s_c906_xram
INCLUDE_COMPONENTS += $(COMPONENTS_SIPEEED)
INCLUDE_COMPONENTS += $(PROJECT_NAME)

CFLAGS += -DROMFS_STATIC_ROOTADDR=0x582f0000

include $(BL_SDK_PATH)/make_scripts_riscv/project_common.mk
```

proj_config.mk 配置如下：
```makefile
#
#compiler flag config domain
#
#CONFIG_TOOLPREFIX :=
#CONFIG_OPTIMIZATION_LEVEL_RELEASE := 1
#CONFIG_M4_SOFTFP := 1

#
#board config domain
#
CONFIG_BOARD_FLASH_SIZE := 2

#firmware config domain
#

#set CONFIG_ENABLE_ACP to 1 to enable ACP, set to 0 or comment this line to disable
#CONFIG_ENABLE_ACP:=1
CONFIG_BL_IOT_FW_AP:=1
CONFIG_BL_IOT_FW_AMPDU:=0
CONFIG_BL_IOT_FW_AMSDU:=0
CONFIG_BL_IOT_FW_P2P:=0
CONFIG_ENABLE_PSM_RAM:=1
#CONFIG_ENABLE_CAMERA:=1
#CONFIG_ENABLE_BLSYNC:=1
#CONFIG_ENABLE_VFS_SPI:=1
CONFIG_ENABLE_VFS_ROMFS:=1
CONFIG_ENABLE_DBG_UARTID_0:=1

CONFIG_ENABLE_ETHMAC:=0
CONFIG_ENABLE_YUV_CAM:=1
CONFIG_CPU_C906:=1
# set easyflash env psm size, only support 4K、8K、16K options
CONFIG_ENABLE_PSM_EF_SIZE:=16K

CONFIG_FREERTOS_TICKLESS_MODE:=0

CONFIG_BT:=0
CONFIG_BT_CENTRAL:=1
CONFIG_BT_OBSERVER:=1
CONFIG_BT_PERIPHERAL:=1
CONFIG_BT_STACK_CLI:=1
#CONFIG_BT_MESH := 1
CONFIG_BLE_STACK_DBG_PRINT := 1
CONFIG_BT_STACK_PTS := 0
ifeq ($(CONFIG_BT_MESH),1)
CONFIG_BT_MESH_PB_ADV := 1
CONFIG_BT_MESH_PB_GATT := 1
CONFIG_BT_MESH_FRIEND := 1
CONFIG_BT_MESH_LOW_POWER := 1
CONFIG_BT_MESH_PROXY := 1
CONFIG_BT_MESH_GATT_PROXY := 1
endif

#blog enable components format :=blog_testc cli vfs helper
LOG_ENABLED_COMPONENTS:=blog_testc hosal loopset looprt bloop

```

编译命令则如下：
```bash
make CONFIG_CHIP_NAME=BL808 CPU_ID=D0 -j$(nproc) PROJECT_NAME=$(你的具体工程文件夹名)
```

#### 预期结果

运行结果：
![Video](1.mp4)