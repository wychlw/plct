# Run Llama.cpp with Deepseek on Risc-V

## 安装

由于 c910 系列芯片使用的是 XTheadVector(RVV0p7)，而 llama.cpp 官方只支持了 RVV1p0，必须要借助 OpenBLAS 作为后端才能使用上 RVV0p7 指令集。

### 获取工具链

新版 GCC-14 中虽然有了 XTheadVector 的支持，但部分指令与 RVV0p7 是不对应的。强行使用 XTheadVector 会导致编译错误。因此，我们需要使用 RVV0p7 的工具链。

对此可以下载玄铁工具链的源码自行编译，但整体在 SG2042 上编译耗时很长。也可以使用 PLCT ruyisdk 提供的 xthead 工具链。方法如下：

```bash
cd ~
wget https://mirror.iscas.ac.cn/ruyisdk/dist/RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu.tar.xz
tar -xvf RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu.tar.xz
cd RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu/bin
export PATH=$(pwd):$PATH
```

### 编译 OpenBLAS

对于 RVV0p7 的支持暂时只有 OpenBLAS 提供，其余后端，如 OpenBLIS、Llama.cpp GGUF 等都只支持了 RVV1p0。

```bash
cd ~
git clone https://github.com/OpenMathLib/OpenBLAS
cd OpenBLAS
make HOSTCC=gcc TARGET=C910V CC=riscv64-plctxthead-linux-gnu-gcc FC=riscv64-plctxthead-linux-gnu-gfortran
sudo make install PREFIX=~/RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu/riscv64-plctxthead-linux-gnu/sysroot/usr
```

若您是自行编译的玄铁工具链，那么请将 `riscv64-plctxthead-linux-gnu-gcc` 和 `riscv64-plctxthead-linux-gnu-gfortran` 替换为您自己编译的工具链。

请务必注意，若您使用了 PLCT 提供的工具链，OpenBLAS 的安装路径必须是工具链带有的 sysroot 路径下。即 `RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu/riscv64-plctxthead-linux-gnu/sysroot/usr`。若您使用了自行编译的工具链，正常安装到 `/usr/local` 即可。

### 编译 Llama.cpp

Llama.cpp 需要定义使用 OpenBLAS 后端:

```bash
cd ~
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
```

由于原版会默认调用 RVV1p0 的指令集，我们需要修改 `CMakeLists.txt` 文件，将 `-march=rv64gcv` 改为 `-march=rv64gcv0p7`。
```diff

diff --git a/ggml/src/ggml-cpu/CMakeLists.txt b/ggml/src/ggml-cpu/CMakeLists.txt
index 98fd18e..0e6f302 100644
--- a/ggml/src/ggml-cpu/CMakeLists.txt
+++ b/ggml/src/ggml-cpu/CMakeLists.txt
@@ -306,7 +306,7 @@ function(ggml_add_cpu_backend_variant_impl tag_name)
     elseif (${CMAKE_SYSTEM_PROCESSOR} MATCHES "riscv64")
         message(STATUS "RISC-V detected")
         if (GGML_RVV)
-            list(APPEND ARCH_FLAGS -march=rv64gcv -mabi=lp64d)
+            list(APPEND ARCH_FLAGS -march=rv64gcv0p7 -mabi=lp64d)
         endif()
     else()
         message(STATUS "Unknown architecture")
```

```bash
CC=riscv64-plctxthead-linux-gnu-gcc FC=riscv64-plctxthead-linux-gnu-gfortran cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
cmake --build build --config Release -j32
```

若遇到以下问题：
- 找不到 libopenblas.so：请注意上一步的安装路径是否正确
- 找不到 `riscv64-plctxthead-linux-gnu-gcc` 和 `riscv64-plctxthead-linux-gnu-gfortran`：请检查工具链是否正确添加到 PATH 中
- 运行时出现 `Illegal instruction`：请检查是否使用了 RVV0p7 的工具链，同时检查是否正确修改了 `CMakeLists.txt`

### 获取模型

试验了 [DeepSeek-R1-Distill-Llama-8B-GGUF](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Llama-8B-GGUF) Q4_K_M 和 [DeepSeek-R1-Distill-Qwen-1.5B-GGUF](https://huggingface.co/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF) Q2_K 两个模型，均可以在 Llama.cpp 上运行。

不建议采用更大的模型，因为 DeepSeek 会具有大量思考过程，这会消耗非常多的时间。

```bash
cd ~
python3 -m venv venv
source venv/bin/activate
pip install huggingface_hub hf_transfer
cat <<EOF > download_gguf.py
import os
#os.environ["HF_HUB_ENABLE_HF_TRANSFER"]

from huggingface_hub import snapshot_download
snapshot_download(
  repo_id = "unsloth/DeepSeek-R1-Distill-Llama-8B-GGUF",
  local_dir = "DeepSeek-R1-Distill-Llama-8B-GGUF",
  allow_patterns = ["*Q4_K_M*"],
)
EOF
export HF_HUB_ENABLE_HF_TRANSFER=1
python download_gguf.py
```

上面的代码会下载 DeepSeek-R1-Distill-Llama-8B-GGUF Q4_K_M 量化的模型。若需要下载其它模型，可以自行修改 `repo_id`（模型） `local_dir` 和 `allow_patterns`（量化）。更多模型可以在 [Hugging Face](https://huggingface.co/collections/unsloth/deepseek-r1-all-versions-678e1c48f5d2fce87892ace5) 上查看。

*以上都不是原版的 DeepSeek-R1，而是其蒸馏模型。原版 DeepSeek 参数量为 671B，参数量是上面模型的100倍-600倍*

## 运行

### 直接在 CLI 中运行

```bash
cd ~
llama.cpp/build/bin/llama-cli -m DeepSeek-R1-Distill-Llama-8B-GGUF/DeepSeek-R1-Distill-Llama-8B-Q4_K_M.gguf --cache-type-k q8_0 -t 32 --prompt '<｜User｜>[Your words]<｜Assistant｜>' -no-cnv
```

请自行替换 `[Your words]` 为您的输入。`-t 32` 代表使用 32 个线程，可以根据自己的需求调整。`-m` 代表模型路径，请根据自己的模型调整。

*一般而言，SG2042 上 32 线程即可取得叫好结果*

### 交互式运行

```bash
cd ~
llama.cpp/build/bin/llama-server -m DeepSeek-R1-Distill-Llama-8B-GGUF/DeepSeek-R1-Distill-Llama-8B-Q4_K_M.gguf --cache-type-k q8_0 -t 32
```

请自行替换 `-m` 为您的模型路径。`-t 32` 代表使用 32 个线程，可以根据自己的需求调整。


交互式需要采用客户端，其默认 API 位于 `127.0.0.1:8080`，API 采用 OpenAI API 兼容格式，可以使用自行找到的客户端进行交互。

一个 Python 的示例客户端程序如下：
```bash
import requests

user_mask = "<｜User｜>"
assistant_mask = "<｜Assistant｜>"

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
        res += self.text
        res += '\n'
        return res
    

class Conversation:
    message: list[Message]
    url: str

    def __init__(self, url = "http://localhost:8080/completion"):
        self.message = []
        self.url = url

    def __post_chat__(self):
        prompt = start_mask + "\n"
        for msg in self.message:
            prompt += str(msg) + "\n"
        prompt += assistant_mask
        res = requests.post(self.url, json={"prompt": prompt})
        msg = res.json()
        self.message.append(Message(msg["content"], Message.ASSISTANT))
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

输入 `exit` 即可退出。

您可能会发现交互式客户端卡半天才回复，这是因为 DeepSeek 会进行大量的思考过程，最后一次性的输出全部内容。请耐心等待。


## 性能

以下均采用 Milk-V Pioneer, 32T 进行。问题采用 `Hello! Who's there?`

| 模型 | 量化 | ms per token | token per second |
 --- | --- | --- | --- |
| DeepSeek-R1-Distill-Qwen-1.5B-GGUF | Q2_K | 785.58ms | 1.27 |
| DeepSeek-R1-Distill-Qwen-1.5B-GGUF | Q4_K_M | 992.34ms | 1.01 |
| DeepSeek-R1-Distill-Llama-8B-GGUF | Q2_K | 1884.06ms | 0.53 |
| DeepSeek-R1-Distill-Llama-8B-GGUF | Q4_K_M | 1575.40ms | 0.63 |

![1](assets/1.5B_Q2_K.png)
![2](assets/1.5B_Q4_K_M.png)
![3](assets/8B_Q2_K.png)
![4](assets/8B_Q4_K_M.png)

