# Visionfive2 B 扩展 性能对比报告

## 简介

RISC-V 指令集中 B 扩展主要定义了各类功能下的位操作等指令。根据功能的不同，其被分为了 4 个子集：Zba、Zbb（位操作）、Zbc（无进位乘法）、Zbs（单 bit 指令）。

以下为 ruapu 对 Visionfive2 CPU（U74-mc）进行功能检测的结果：
```log
user@starfive:~/dev/ruapu$ ./ruapu
i = 1
m = 1
a = 1
f = 1
d = 1
c = 1
v = 0
zba = 1
zbb = 1
zbc = 0
zbs = 0
zbkb = 0
zbkc = 0
zbkx = 0
zcb = 0
zfa = 0
zfbfmin = 0
zfh = 0
zfhmin = 0
zicond = 0
zicsr = 1
zifencei = 1
zmmul = 1
zvbb = 0
zvbc = 0
zvfh = 0
zvfhmin = 0
zvfbfmin = 0
zvfbfwma = 0
zvkb = 0
zvl32b = 0
zvl64b = 0
zvl128b = 0
zvl256b = 0
zvl512b = 0
zvl1024b = 0
xtheadba = 0
xtheadbb = 0
xtheadbs = 0
xtheadcondmov = 0
xtheadfmemidx = 0
xtheadfmv = 0
xtheadmac = 0
xtheadmemidx = 0
xtheadmempair = 0
xtheadsync = 0
xtheadvdot = 0
spacemitvmadot = 0
spacemitvmadotn = 0
spacemitvfmadot = 0
i
m
a
f
d
c
zba
zbb
zicsr
zifencei
zmmul
```

可以看到，其指令集为：`rv64imafdc_zicntr_zicsr_zifencei_zihpm_zba_zbb`，即只实现了部分 B 扩展。因此本次对 B 扩展的测试局限于是否启用 Zba、Zbb。

## 测试环境

本次测试采用系统环境如下：
- 系统采用 starfive 官方发布最新 Debian 镜像：bookworm/sid
- 内核版本 6.6.20
- gcc 版本为 Debian 12.2.0-10
- 外挂风扇保证散热

详见：
```log
user@starfive
-------------
OS: Debian GNU/Linux bookworm bookworm/sid riscv64
Host: StarFive VisionFive 2 v1.3B
Kernel: Linux 6.6.20-starfive
Init System: systemd 252.4-1
Uptime: 8 hours, 47 mins
Loadavg: 3.49, 3.39, 1.87
Processes: 199
Packages: 1350 (dpkg)
Shell: bash 5.2.2
LM: sshd (TTY)
Terminal: /dev/pts/2
Terminal Size: 123 columns x 63 rows (987px x 1080px)
Terminal Theme: #FCFCFC (FG) - #232627 (BG) [Dark]
CPU: sifive,u74-mc rv64gc (4) @ 1.50 GHz
CPU Cache (L1): 4x32.00 KiB (I), 4x32.00 KiB (D)
CPU Cache (L2): 2.00 MiB (U)
CPU Usage: 6%
Memory: 379.26 MiB / 3.78 GiB (10%)
Swap: Disabled
Disk (/): 3.77 GiB / 13.02 GiB (29%) - ext4
Public IP: 117.129.58.72 (Shanghai, CN)
Local IP (eth0): 10.7.42.208/24 fe80::1d0e:d406:51f6:1b94/64 (6c:cf:39:00:54:34)
DNS: 10.7.42.1
Date & Time: 2024-08-05 07:38:23
Locale: C
Users: user@10.7.42.1 - login time 2024-08-04 23:26:35
Sound: Dummy Output (100%)
Weather: +13°C - Clear  (not found)
Network IO (eth0): 2.55 KiB/s (IN) - 4.10 KiB/s (OUT) *
Disk IO (INTEL MEMPEK1W016GA): 0 B/s (R) - 0 B/s (W)
Disk IO (mtdblock0): 0 B/s (R) - 0 B/s (W)
Disk IO (mtdblock1): 0 B/s (R) - 0 B/s (W)
Disk IO (mtdblock2): 0 B/s (R) - 0 B/s (W)
Disk IO (mtdblock3): 0 B/s (R) - 0 B/s (W)
Physical Disk (INTEL MEMPEK1W016GA): 13.41 GiB [SSD, Fixed]
Physical Disk (mtdblock0): 512.00 KiB [SSD, Fixed]
Physical Disk (mtdblock1): 64.00 KiB [SSD, Fixed]
Physical Disk (mtdblock2): 4.00 MiB [SSD, Fixed]
Physical Disk (mtdblock3): 10.00 MiB [SSD, Fixed]
Version: fastfetch 2.21.0-172 (riscv)
```
```log
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/riscv64-linux-gnu/12/lto-wrapper
Target: riscv64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian 12.2.0-10' --with-bugurl=file:///usr/share/doc/gcc-12/README.Bugs --enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=/usr --with-gcc-major-version-only --program-suffix=-12 --program-prefix=riscv64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-libitm --disable-libquadmath --disable-libquadmath-support --enable-plugin --enable-default-pie --with-system-zlib --enable-libphobos-checking=release --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --disable-werror --disable-multilib --with-arch=rv64gc --with-abi=lp64d --enable-checking=release --build=riscv64-linux-gnu --host=riscv64-linux-gnu --target=riscv64-linux-gnu
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 12.2.0 (Debian 12.2.0-10)
```

## 测试工具及结果

coremark 是一个简单的基准测试程序，其能测试单核处理器核心性能。其结果具有良好的可比较性。

本次测试共运行三个测试套：coremark 与 coremark-pro 与 UnixBench-Double-Precision Whetstone

### coremark

coremark 共分为两次测试：性能测试和验证测试。

测试命令如下：
- 带有 B 扩展
```bash
make XCFLAGS="-march=rv64gc_zba_zbb"
```
- 不带 B 扩展
```bash
make XCFLAGS="-march=rv64gc"
```

接下来是性能测试的结果：

- 带有 B 扩展
```log
CoreMark 1.0 : 5493.407911 / GCC12.2.0 -O2 -march=rv64gc_zba_zbb -DPERFORMANCE_RUN=1  -lrt / Heap
```
- 不带 B 扩展
```log
CoreMark 1.0 : 5044.251846 / GCC12.2.0 -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt / Heap
```

原始结果详见：[带有 B 扩展](./with_b/)，[不带 B 扩展](./no_b/)

可见，带有 B 扩展的测试得到了更高的分数，提升了约 **$21.97\%$**

### coremark-pro

相比于 coremark，coremark-pro 是一个更为全面和高级的处理器测试套件，其增加了多核、整数和浮点数的支持等。

需要注意，所有 coremark-pro 的 sha 测试均由于段错误而失败，以下均为去除 sha 测试的结果。

测试命令如下：
- 带有 B 扩展
```bash
make TARGET=linux64 CFLAGS='-march=rv64gc_zba_zbb' XCMD='-c4 -v0' certify-all
```
- 不带 B 扩展
```bash
make TARGET=linux64 CFLAGS='-march=rv64gc' XCMD='-c4 -v0' certify-all
```

- 带有 B 扩展

| 测试名                    | 多核成绩 | 单核成绩 | 缩放比例 |
| ------------------------- | -------- | -------- | -------- |
| cjpeg-rose7-preset        | 63.29    | 16.92    | 3.74     |
| core                      | 0.28     | 0.07     | 4.00     |
| linear_alg-mid-100x100-sp | 20.09    | 5.22     | 3.85     |
| loops-all-mid-10k-sp      | 0.87     | 0.23     | 3.78     |
| nnet_test                 | 0.62     | 0.18     | 3.44     |
| parser-125k               | 19.90    | 4.93     | 4.04     |
| radix2-big-64k            | 88.34    | 24.76    | 3.57     |
| zip-test                  | 29.85    | 7.04     | 4.24     |

- 不带 B 扩展

| 测试名                    | 多核成绩 | 单核成绩 | 缩放比例 |
| ------------------------- | -------- | -------- | -------- |
| cjpeg-rose7-preset        | 63.69    | 16.56    | 3.85     |
| core                      | 0.28     | 0.07     | 4.00     |
| linear_alg-mid-100x100-sp | 20.02    | 5.22     | 3.84     |
| loops-all-mid-10k-sp      | 0.87     | 0.23     | 3.78     |
| nnet_test                 | 0.61     | 0.18     | 3.39     |
| parser-125k               | 19.90    | 5.18     | 3.84     |
| radix2-big-64k            | 87.47    | 24.75    | 3.53     |
| zip-test                  | 25.81    | 7.41     | 3.48     |




原始结果详见：[带有 B 扩展](./with_b/coremark-pro/)，[不带 B 扩展](./no_b/coremark-pro/)

可以看到，B 扩展主要对特定应用，如 zip 压缩/解压中具有更大的效果。而在另外大部分只用到传统 rv64gc 指令集上的加速效果则不明显。对于有加速效果的应用场景下，其性能提升约在 **$10\%-15\%$** 之间。

### UnixBench-Double-Precision WhetstoVV

测试命令如下：
- 带有 B 扩展
```bash
UB_GCC_OPTIONS="-march=rv64gc_zba_zbb" ./Run whetstone-double
```
- 不带 B 扩展
```bash
UB_GCC_OPTIONS="-march=rv64gc" ./Run whetstone-double
```

- 带有 B 扩展
```log
========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: starfive: GNU/Linux
   OS: GNU/Linux -- 6.6.20-starfive -- #1 SMP Sun May  5 22:39:25 CST 2024
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   10:25:52 up 11:35,  3 users,  load average: 0.83, 0.79, 0.75; runlevel Aug

------------------------------------------------------------------------
Benchmark Run: Mon Aug 05 2024 10:25:52 - 10:28:14
4 CPUs in system; running 1 parallel copy of tests

Double-Precision Whetstone                      492.0 MWIPS (10.0 s, 7 samples)

System Benchmarks Partial Index              BASELINE       RESULT    INDEX
Double-Precision Whetstone                       55.0        492.0     89.5
                                                                   ========
System Benchmarks Index Score (Partial Only)                           89.5

------------------------------------------------------------------------
Benchmark Run: Mon Aug 05 2024 10:28:14 - 10:30:38
4 CPUs in system; running 4 parallel copies of tests

Double-Precision Whetstone                     1955.5 MWIPS (10.0 s, 7 samples)

System Benchmarks Partial Index              BASELINE       RESULT    INDEX
Double-Precision Whetstone                       55.0       1955.5    355.6
                                                                   ========
System Benchmarks Index Score (Partial Only)                          355.6
```

- 不带 B 扩展
```log
========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: starfive: GNU/Linux
   OS: GNU/Linux -- 6.6.20-starfive -- #1 SMP Sun May  5 22:39:25 CST 2024
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   10:34:31 up 11:44,  3 users,  load average: 0.83, 1.31, 1.12; runlevel Aug

------------------------------------------------------------------------
Benchmark Run: Mon Aug 05 2024 10:34:31 - 10:36:53
4 CPUs in system; running 1 parallel copy of tests

Double-Precision Whetstone                      492.1 MWIPS (10.0 s, 7 samples)

System Benchmarks Partial Index              BASELINE       RESULT    INDEX
Double-Precision Whetstone                       55.0        492.1     89.5
                                                                   ========
System Benchmarks Index Score (Partial Only)                           89.5

------------------------------------------------------------------------
Benchmark Run: Mon Aug 05 2024 10:36:53 - 10:39:17
4 CPUs in system; running 4 parallel copies of tests

Double-Precision Whetstone                     1955.3 MWIPS (10.0 s, 7 samples)

System Benchmarks Partial Index              BASELINE       RESULT    INDEX
Double-Precision Whetstone                       55.0       1955.3    355.5
                                                                   ========
System Benchmarks Index Score (Partial Only)                          355.5

```

可以看到，由于 zba zbb 与浮点无关，在执行浮点相关测试时无性能提升。

## 测试结论

Visionfive2 具有的 CPU 核 U74-mc 实现了 B 扩展中的 zba zbb 两个子集。综合来看，B 扩展在特定能用到该扩展的任务上有着 10%-20% 的性能提升。