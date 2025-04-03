# Clang B 扩展 对比报告

## 测试环境

本次测试分别在以下环境测试：

- JH7100
- K1

### JH7110

#### 硬件环境

- CPU: JH7110 (U74 * 4 @ 1.50 GHz)
- RAM: 8GB
- March: rv64imafdc_zba_zbb_zicbop_zicsr_zifencei_zihintpause_zmmul

### 操作系统

- OS: Ubuntu 24.04.2 LTS riscv64
- Kernel: Linux 6.8.0-52-generic

### Clang版本

- Clang: 19.1.1

### K1

#### 硬件环境

- CPU: K1 (X60 * 8 @ 1.60 GHz)
- RAM: 4GB
- March: rv64imafdc_zba_zbb_zbc_zbs_zbkc_zfh_zfhmin_zicbop_zicond_zicsr_zifencei_zihintpause_zmmul_zvfh_zvfhmin_zvl32b_zvl64b_zvl128b_zvl256b_spacemitvmadot_spacemitvmadotn

#### 操作系统

- OS: Bianbu 2.1.1 riscv64
- Kernel: Linux 6.6.63

#### Clang版本

- Clang: 19.1.1

## 测试程序

本次测试使用了以下测试程序：

- Coremark [eembc/coremark](https://github.com/eembc/coremark)
- Coremark Pro [eembc/coremark-pro](https://github.com/eembc/coremark-pro)
- CSiBE [szeged/csibe](https://github.com/szeged/csibe)
- Unix Bench [kdiucas/byte-unixbench](https://github.com/kdlucas/byte-unixbench)

### Coremark

测试命令如下：

```bash
CC=clang CXX=clang++ XCFLAGS="-march=rv64gc"
```

对于其它 march ，需要修改 `XCFLAGS` 中的 `rv64gc` 为对应的值。

### Coremark Pro

需要应用 [0001-Modify-to-clang-toolchain-coremark-pro](./0001-Modify-to-clang-toolchain-coremark-pro.patch) 补丁，启用 Clang 编译器支持。

测试命令如下：

```bash
CC=clang CXX=clang++ make TARGET=linux64 XCFLAGS='-march=rv64gc' XCMD='-c4 -v0' certify-all
```

对于其它 march ，需要修改 `XCFLAGS` 中的 `rv64gc` 为对应的值。

### CSiBE

添加了 `riscv_gc` `riscv_gc_zba_zbb` `riscv_gc_zba_zbb_zbc_zbs` 三个编译目标，应用 [0001-Modify-to-clang-toolchain-csibe](./0001-Modify-to-clang-toolchain-csibe.patch) 补丁。

测试命令如下：

```bash
./csibe.py --build-dir=build/ --toolchain riscv_gc CSiBE-v2.1.1
```

对于其它 march ，需要修改 `--toolchain` 中的 `riscv_gc` 为对应的值。

### Unix Bench

测试命令如下：

```bash
CC=clang CXX=clang++ UB_GCC_OPTIONS="-march=rv64gc" ./Run
```

对于其它 march ，需要修改 `UB_GCC_OPTIONS` 中的 `rv64gc` 为对应的值。

## 测试结果

整理后的测试结果如下：

- jh7110 rv64gc: [nb.md](./jh7110/nb.md)
- jh7110 rv64gc_zba_zbb: [wb.md](./jh7110/wb.md)

- k1 rv64gc: [nb.md](./k1/nb.md)
- k1 rv64gc_zba_zbb_zbc_zbs: [wb.md](./k1/wb.md)

原始测试结果位于同名文件夹下：

- jh7110 rv64gc: [nb](./jh7110/nb/)
- jh7110 rv64gc_zba_zbb: [wb](./jh7110/wb/)

- k1 rv64gc: [nb](./k1/nb/)
- k1 rv64gc_zba_zbb_zbc_zbs: [wb](./k1/wb/)

### jh7110

| 测试项目                                               | jh7110 rv64gc     | jh7110 rv64gc_zba_zbb | diff percentage |
| ------------------------------------------------------ | ----------------- | --------------------- | --------------- |
| Coremark (Score, higher is better)                     | 3794.346424       | 4055.698256           | 6.89%           |
| Coremark Pro Single Core (Score, higher is better)     | 695.67            | 751.54                | 8.03%           |
| Coremark Pro Multi Core (Score, higher is better)      | 2488.52           | 2672.56               | 7.40%           |
| CSiBE (Average length, lower is better)                | 5381.571197411004 | 5372.525889967637     | -0.17%          |
| CSiBE (Total length, lower is better)                  | 3325811           | 3320221               | -0.17%          |
| Unix Bench Single Core (Index Score, higher is better) | 256.7             | 258.3                 | 0.62%           |
| Unix Bench Multi Core (Index Score, higher is better)  | 877.5             | 882.3                 | 0.54%           |

### k1

| 测试项目                                               | k1 rv64gc         | k1 rv64gc_zba_zbb_zbc_zbs | diff percentage |
| ------------------------------------------------------ | ----------------- | ------------------------- | --------------- |
| Coremark (Score, higher is better)                     | 4252.604720       | 4311.583788               | 1.39%           |
| Coremark Pro Single Core (Score, higher is better)     | 307.45            | 305.59                    | -0.06%          |
| Coremark Pro Multi Core (Score, higher is better)      | 1047.89           | 1059.61                   | 1.12%           |
| CSiBE (Average length, lower is better)                | 5349.131067961165 | 5336.493527508091         | -0.24%          |
| CSiBE (Total length, lower is better)                  | 3305763           | 3297953                   | -0.24%          |
| Unix Bench Single Core (Index Score, higher is better) | 284.5             | 284.0                     | -0.18%          |
| Unix Bench Multi Core (Index Score, higher is better)  | 1630.7            | 1633.3                    | 0.16%           |