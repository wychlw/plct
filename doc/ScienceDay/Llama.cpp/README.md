# Llama.cpp on Risc-V

介于GGML原生支持了RVV，就用BLAS做后端了嗯。

## RVV

注：目前 RVV 版本的 Llama.cpp 似乎只支持 xlen=64/128。

兼容以下量化：

q2k q3k q4k q6k q8k

编译方式如下：

```bash
mkdir build
cd build
cmake .. -DRISCV=1 -DGGML_RVV=1 -DGGML_RV_ZFH=1
make -j$(nproc)
```

（一般而言RVV1p0的CPU都带有zfh扩展，没带记得关掉嗯）


### XtheadVctor

（没错它支持xtheadvector了（虽然是科学日后续才加的））

```bash
mkdir build
cd build
cmake .. -DRISCV=1 -DGGML_RVV=1 -DGGML_XTHEADVECTOR=1 -DGGML_RV_ZFH=0
make -j$(nproc)
```

模型建议使用 Q4K 量化