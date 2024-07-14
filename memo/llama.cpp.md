# Run LLAMA.CPP with GLM4 on RISC-V

## 简介

llama.cpp 在 3 月份有了 RVV 支持，且 7 月初完成了 GLM4 的移植，可以用其跑 llm server。

## 安装

### OpenBLAS

llama.cpp 的 rvv 支持依赖于 OpenBLAS，分为 rvv0p7(Xtheadvector) 和 rvv1p0 几个版本。以下为安装流程：

下载 OpenBLAS 库：
```bash
git clone https://github.com/OpenMathLib/OpenBLAS
cd OpenBLAS
```

对于原生编译 rvv0p7：
```bash
make HOSTCC=gcc TARGET=C910V CC=riscv64-unknown-linux-gnu-gcc FC=riscv64-unknown-linux-gnu-gfortran
```

对于原生编译 rvv1p0：
```bash
make HOSTCC=gcc TARGET=x280 NUM_THREADS=8 CC=riscv64-unknown-linux-gnu-gcc FC=riscv64-unknown-linux-gnu-gfortran
```

对于交叉编译（TARGET 如上）：
```bash
make CC=unknown-linux-gnu-gcc FC=riscv64-unknown-linux-gnu-gfortran HOSTCC=gcc TARGET=x280 CROSS=1 CROSS_SUFFIX=unknown-linux-gnu- 
```

之后安装，默认目录为`/opt/OpenBLAS`，请记住填写的安装目录：
```bash
make install PREFIX=path/to/install
```

### llama.cpp

接下来安装 llama.cpp，我们需要它来编译、量化、运行模型。

llama.cpp 在 RISC-V 上支持 BLAS 和 BLIS（和 Vulkan，如果它有着足够好的 GPU 的话……）后端。

首先下载它：
```bash
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
```

采用 OpenBLAS 后端编译：
```bash
cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DRISCV=1

cmake --build build --config Release
```

交叉编译则如下：
```bash
cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DRISCV=1 -DRISCV_CROSS_COMPILE=1 -DRISCV_CROSS_COMPILE=1

cmake --build build --config Release
```

可执行程序会被编译到 `build/bin` 下。

#### 模型编译/量化准备

模型编译/量化也需要使用 llama.cpp。由于建议这一步在 x86-64 的**高性能**机器上进行，我们还需要来一个 x86 机器上运行的版本的。

一般而言包管理器会已经提供了 OpenBLAS 这个库，下载即可。
```bash
sudo apt install libopenblas
```

其编译命令如下：
```bash
cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
cmake --build build --config Release
```

### GLM4

**以下在 x86 下**

采用 GLM4-chat 模型。其参数量为 9B，作为最新的模型效果较好。

#### 下载

模型在 Hugging Face 上进行下载。需要安装 git-lfs 模块。

对于 git-lfs，一般会在包管理器中提供。使用 apt/yum/pacman 安装即可：
```bash
sudo apt install git-lfs
```

而后 clone 整个模型。**注意整个模型需要良好的*外部*网络连接，总共高达 20G 左右，需要做好准备**
```bash
git lfs install
git clone https://huggingface.co/THUDM/glm-4-9b
```

#### 编译合并模型

直接下载的模型是不能用的，需要合并后使用。在此我们需要使用 Python 环境。进入 llama.cpp 的文件夹，首先创造一个虚拟环境避免污染系统：
```bash
cd llama.cpp
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

而后进行编译转换：
```bash
python ./convert_hf_to_gguf.py ../glm-4-9b-chat/
```

输出的模型为`ggml-model-f16.gguf`

#### 量化

编译玩的模型采用 f16 作为数据类型。为了减少运算量及使用 rvv，需要量化。

rvv 目前仅支持：
- Q8
- Q8_K
- Q6_K
- Q4_K
量化。

进行量化（以 Q6_K 为例）：
```bash
build/bin/llama-quantize ../glm-4-9b-chat/ggml-model-f16.gguf ../glm-4-9b-chat/ggml-model-Q6_K.gguf Q6_K
```

输出的模型`ggml-model-Q6_K.gguf`复制到 RISC-V 直接使用。

## 使用

在此，我们使用 llama-server 来创建一个网络服务器，提供服务：
```bash
build/bin/llama-server -m ../glm-4-9b-chat/ggml-model-Q6_K.gguf -n 64 -t $(thread_count)
```

thread_count 为线程数量，根据 CPU 核心数来定。

### 提示词

GLM4 的提示词如下：
- 对话开头：`[gMASK]<sop>\n`
- 系统：`<|system|>\n`
- AI：`<|assistant|>\n`
- 用户：`<|user|>\n`

下面一段是一段对话示例，展现了如下对话：
- 系统：You are a helpful assistant
- 用户：Hello
- AI：Hi there
- 用户：How are you?
```text
[gMASK]<sop><|system|>\nYou are a helpful assistant<|user|>\nHello<|assistant|>\nHi there<|user|>\nHow are you?<|assistant|>
```

### API

向 `http://addr:port/completion` 发送 post，post 内容为一个 json：
```json
{"prompt": $(prompt)}
```

回复内容为一个 json，位于 `res.content` 中。

### 示例程序

一个 Python 的示例使用程序如下：
```bash
import requests

start_mask = "[gMASK]<sop>"
system_mask = "<|system|>"
user_mask = "<|user|>"
assistant_mask = "<|assistant|>"

class Message:
    
    SYSTEM = 1
    USER = 2
    ASSISTANT = 3

    role: int
    text: str

    def __init__(self, text, role = 2):
        self.text = text
        self.role = role

    def __str__(self):
        res = ""
        if self.role == Message.SYSTEM:
            res += system_mask
        elif self.role == Message.USER:
            res += user_mask
        elif self.role == Message.ASSISTANT:
            res += assistant_mask
        res += self.text
        res += '\n'
        return res
    

class Conversation:
    message: list[Message]
    url: str

    def __init__(self, system_promote = "你是一个名为 GLM-4 的人工智能助手。你是基于智谱 AI 训练的语言模型 GLM-4 模型开发的，你的任务是针对用户的问题和要求提供适当的答复和支持。", url = "http://localhost:8080/completion"):
        self.message = [
            Message(system_promote, Message.SYSTEM)
        ]
        self.url = url

    def __post_chat__(self):
        prompt = start_mask + "\n"
        for msg in self.message:
            prompt += str(msg) + "\n"
        prompt += assistant_mask
        res = requests.post(self.url, json={"prompt": prompt})
        msg = res.json()
        self.message.append(Message(msg["content"], Message.SYSTEM))
        return msg["content"]
    
    def chat(self, text):
        self.message.append(Message(text, Message.USER))
        return self.__post_chat__()
    
def main():
    conv = Conversation()
    while True:
        text = input("You: ")
        if text == "exit":
            break
        print("Assistant:", conv.chat(text))

if __name__ == "__main__":
    main()

```