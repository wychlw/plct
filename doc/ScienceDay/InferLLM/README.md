# InferLLM On SG2042

## 环境信息

系统：RevyOS
工具链：T-Head GCC&G++

## 搭建步骤

### 下载工具链

```bash
sudo sed -i '1ideb https://mirror.iscas.ac.cn/revyos/revyos-c910v/ revyos-c910v main' /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential gcc g++
sudo apt autoremove --purge
```

### 构建程序

带 RVV 的：
```bash
git clone https://github.com/MegEngine/InferLLM
mkdir build
cd build
cmake .. -DINFER_ARCH=rvv0p7
make -j$(nproc)
```

不带 RVV 的（进行对比）：
```bash
git clone https://github.com/MegEngine/InferLLM.git
mkdir build
cd build
cmake .. -DINFER_ARCH=none
make -j$(nproc)
```

注：RVV 加速在核心数较小的情况下会更有用，核心数较多时反而可能拖累整体性能。

### 获取模型

此处采用最新最热 ChatGLM3 模型，可以自己构建也可以直接下载。

构建过程：
```bash
cd application/chatglm
python ./convert.py -v 3 -o path/to/chatglm3-fp32.bin
cd -
cd build
./quantizer path/to/chatglm3-fp32.bin path/to/chatglm3-q4.bin
```
建议整个过程中保持极为良好的网络链接（与 huggingface 的），整个模型较大。


直接下载链接：
链接：https://pan.baidu.com/s/1CMdks4T3r0Kyk5Le2CruVw?pwd=wisd 提取码：wisd 


### 运行模型

```bash
./chatglm -m ./chatglm3-q4.bin -v 3 --mmap -t 64
```

- `-v` 代表 chatglm 版本（一定要，否则默认 chatglm1）
- `-t` 代表线程数