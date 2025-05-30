# 中科院软件所 2024/2025 科学日活动资料

## 2024

### 大模型

见 [InferLLM](./InferLLM/README.md)

### LuaJIT

见 [LuaJIT](./LuaJIT/README.md)

### OpenMPI

见 [OpenMPI](./OpenMPI/README.md)

### RuyiSDK 展示

见 [RuyiToolchain](./RuyiToolchain/README.md)

### Duo 人脸识别
 
见 [Face On Duo](./FaceOnDuo/README.md)

## 2025

### Llama.cpp

见 [Llama.cpp](./LlamaCpp/README.md)

### EIC7700 大模型

见他们的文档吧：https://milkv.io/zh/docs/megrez/development-guide/runtime-sample/deepseek-r1

目前他们没有开放大模型的量化工具。16g的版本智能运行0.5B的模型。调设备树是无法让NPU运存超过6g的我也不知道为什么，但是能往小了调w

建议手动更改下运行逻辑带上历史记录（能不那么蠢x），然后重新编译就行。它提示要 half.h 的话给它这个文件：`https://github.com/signetlabdei/rmw_desert/blob/main/src/desert_classes/half.hpp`

有些模板参数手动根据提示添加即可。

### OpenMPI

编译见 [OpenMPI](./OpenMPI/README.md)

Demo见 [LAMMPS](https://github.com/Arielfoever/Work-PLCT/tree/master/show)

~注：实际RV跑这玩意需要挺长时间，建议旁边视频~

### Box64

见 [Box64](./Box64/README.md)
WPS 见 [WPS](./Box64/WPS.md)
配套的游戏（请自行购买？）见 [Turing Complete](./Box64/TuringComplete.md)