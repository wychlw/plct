# OpenCloudOS-Stream RISC-V 测试报告

## 介绍

本报告主要针对 OpenCloudOS-Stream 在 RISC-V 架构上的测试结果进行总结。

## 测试环境

本测试报告基于的硬件环境为Milk-V Pioneer v1.3，详细配置信息如下：
- CPU: SG2042
- 内存: 128GB
- 存储：
  - 64GB TF卡
  - 1TB NVMe SSD

操作系统基于 2025年6月10日的 OpenCloudOS-Stream 版本，采用linuxboot进行引导，镜像下载地址为： https://mirrors.opencloudos.tech/opencloudos-stream/releases/23/images/riscv64/sdcard/ocs_developer_sdcard-linuxboot.img.xz

GCC版本采用镜像自带的版本，为GCC12。该版本GCC不支持xtheadvector等定制指令集扩展，因此测试基准架构为RV64GC。

## 系统安装

系统安装方法可见[支持矩阵](https://matrix.ruyisdk.org/board/Pioneer/openCloudOS-README_linuxboot/)

## 测试内容

本次测试主要针对性能和内核功能两个部分进行验证。

性能测试部分采用以下测试工具进行测试：
- Unix Bench
- fio
- STREAM
- lmbench
- tinymembench
- ramspeed
- 7zip
- openssl

内核功能测试部分采用以下测试工具进行测试：
- LTP (Linux Test Project)
  - 主要测试部分
  - posix兼容测试
- trinity

## 测试结果

测试详细数据位于 [datas.md](./datas.md) 文件中。

### 性能测试结果

#### Unix Bench

UnixBench是一个unix系统下的性能测试工具，主要用于评估系统的整体性能，受到硬件和操作系统配置的差异，对单线程和多线程性能进行评估。

##### 测试执行过程

下载源码包并解压：

```bash
wget https://github.com/kdlucas/byte-unixbench/archive/refs/tags/v6.0.0.tar.gz
tar -xf v6.0.0.tar.gz
cd byte-unixbench-6.0.0/UnixBench/
```

编译测试工具：

```bash
make -j$(nproc)
```

##### 测试结果

###### 单线程性能


```log
========================================================================
   BYTE UNIX Benchmarks (Version 6.0.0)

   System: riscv64.developer.ocs23: GNU/Linux
   OS: GNU/Linux -- 6.6.68 -- #1 SMP Thu Apr 10 17:26:47 CST 2025
   Machine: riscv64 (riscv64)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   01:13:57 up 20 min,  2 users,  load average: 0.07, 0.06, 0.04; runlevel 2023-02-15

------------------------------------------------------------------------
Benchmark Run: Wed Jun 11 2025 01:13:57 - 01:42:14
64 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables       14451052.2 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     2881.7 MWIPS (10.0 s, 7 samples)
Execl Throughput                                657.3 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        196598.7 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           54358.3 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        607715.1 KBps  (30.0 s, 2 samples)
Pipe Throughput                              360477.4 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  33523.7 lps   (10.0 s, 7 samples)
Process Creation                               1040.9 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   1590.1 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1265.5 lpm   (60.0 s, 2 samples)
System Call Overhead                         486220.3 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   14451052.2   1238.3
Double-Precision Whetstone                       55.0       2881.7    524.0
Execl Throughput                                 43.0        657.3    152.9
File Copy 1024 bufsize 2000 maxblocks          3960.0     196598.7    496.5
File Copy 256 bufsize 500 maxblocks            1655.0      54358.3    328.4
File Copy 4096 bufsize 8000 maxblocks          5800.0     607715.1   1047.8
Pipe Throughput                               12440.0     360477.4    289.8
Pipe-based Context Switching                   4000.0      33523.7     83.8
Process Creation                                126.0       1040.9     82.6
Shell Scripts (1 concurrent)                     42.4       1590.1    375.0
Shell Scripts (8 concurrent)                      6.0       1265.5   2109.2
System Call Overhead                          15000.0     486220.3    324.1
                                                                   ========
System Benchmarks Index Score                                         378.8
```

可以看到，单线程测试综合性能得分为378.8。

与其对比，RevyOS上rv64gc结果为395.1；添加自定义指令集扩展结果为389.2。


###### 多线程性能

多线程性能采用32个核心并行执行测试，测试结果如下：

```log
========================================================================
   BYTE UNIX Benchmarks (Version 6.0.0)

   System: riscv64.developer.ocs23: GNU/Linux
   OS: GNU/Linux -- 6.6.68 -- #1 SMP Thu Apr 10 17:26:47 CST 2025
   Machine: riscv64 (riscv64)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   01:43:56 up 50 min,  2 users,  load average: 4.00, 4.08, 2.31; runlevel 2023-02-15

------------------------------------------------------------------------
Benchmark Run: Wed Jun 11 2025 01:43:56 - 02:13:13
64 CPUs in system; running 32 parallel copies of tests

Dhrystone 2 using register variables      462021668.7 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                    92121.9 MWIPS (10.0 s, 7 samples)
Execl Throughput                              13535.8 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks       5715881.9 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks         1624012.8 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks      11155348.1 KBps  (30.0 s, 2 samples)
Pipe Throughput                            11115105.8 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 921525.4 lps   (10.0 s, 7 samples)
Process Creation                              10606.5 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                  34316.3 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   5576.4 lpm   (60.1 s, 2 samples)
System Call Overhead                       15505305.8 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0  462021668.7  39590.5
Double-Precision Whetstone                       55.0      92121.9  16749.4
Execl Throughput                                 43.0      13535.8   3147.9
File Copy 1024 bufsize 2000 maxblocks          3960.0    5715881.9  14434.0
File Copy 256 bufsize 500 maxblocks            1655.0    1624012.8   9812.8
File Copy 4096 bufsize 8000 maxblocks          5800.0   11155348.1  19233.4
Pipe Throughput                               12440.0   11115105.8   8935.0
Pipe-based Context Switching                   4000.0     921525.4   2303.8
Process Creation                                126.0      10606.5    841.8
Shell Scripts (1 concurrent)                     42.4      34316.3   8093.5
Shell Scripts (8 concurrent)                      6.0       5576.4   9294.0
System Call Overhead                          15000.0   15505305.8  10336.9
                                                                   ========
System Benchmarks Index Score                                        8072.8
```

可以看到，多线程测试综合性能得分为8072.8，倍率约为0.67。

与其对比，RevyOS上rv64gc结果为9119.9；添加自定义指令集扩展结果为9146.4。

<!-- #### fio

fio是一个灵活的I/O测试工具，可以用于测试磁盘和文件系统的性能。我们使用fio对NVMe SSD测试。

##### 测试执行过程

下载fio源码包并解压：

```bash
wget https://github.com/axboe/fio/archive/refs/tags/fio-3.40.tar.gz
tar -xf fio-3.40.tar.gz
cd fio-fio-3.40/
```

编译测试工具：

```bash
make -j$(nproc)
```

测试脚本（分别对）：128K、512K、1M块大小进行测试：
```bash
disk=\nvme0n1p4
numjobs=10
iodepth=10
mkdir -p /test
for rw in read write randread randwrite randrw;do
    for bs in 128 512 1024;do
        mkfs.ext4 -F -E lazy_itable_init=0 /dev/$disk
        mount /dev/$disk /test
        if [ $rw == "randrw" ];then
            ./fio -filename=/test/fio -direct=1 -iodepth ${iodepth} -thread -rw=$rw -rwmixread=70 -ioengine=libaio -bs=${bs}k -size=32G -numjobs=${numjobs} -runtime=30 -group_reporting -name=job1
        else
            ./fio -filename=/test/fio -direct=1 -iodepth ${iodepth} -thread -rw=$rw -ioengine=libaio -bs=${bs}k -size=32G -numjobs=${numjobs} -runtime=30 -group_reporting -name=job1
        fi
        umount /test
        sleep 20
    done
done
``` -->

#### STREAM

STREAM是一个内存带宽测试工具，主要用于评估系统的内存性能。

##### 测试执行过程

下载STREAM源码包并解压：

```bash
git clone https://github.com/jeffhammond/STREAM/ --depth=1
cd STREAM
```

编译测试工具：

```bash
gcc -fopenmp -O -DSTREAM_ARRAY_SIZE=128000000 stream.c -o fstream128M
```

测试中我们使用了128M的数组大小进行测试。理论上应当采用4倍以上三级缓存大小的数组进行测试，SG2042的三级缓存为64MB。但是在`2**27` 以上的大小上会产生 relocation truncated to fit 编译错误，因此采用128M作为测试大小。

单线程测试：
```bash
export OMP_NUM_THREADS=1
export GOMP_CPU_AFFINITY=0
sync && sysctl -w vm.drop_caches=3
./fstream128M
```

多线程测试：
```bash
export OMP_NUM_THREADS=`nproc`
export GOMP_CPU_AFFINITY=0-`expr $(nproc) - 1`
sync && sysctl -w vm.drop_caches=3
./fstream128M
```

##### 测试结果

单线程测试结果：

```log
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:            7253.9     0.285697     0.282329     0.303533
Scale:           8610.0     0.242097     0.237863     0.256422
Add:             6924.6     0.445540     0.443638     0.451358
Triad:           7303.8     0.427361     0.420603     0.442392
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
```

多线程测试结果：

```log
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:            7253.1     0.285339     0.282361     0.302954
Scale:           8687.7     0.240137     0.235735     0.256916
Add:             6914.0     0.446022     0.444315     0.450160
Triad:           7290.2     0.427860     0.421386     0.441295
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
```

可以看到带宽在线程间差距不大，在7000MB/s左右。

与其对比，RevyOS上rv64gc结果为；添加自定义指令集扩展结果为。

#### lmbench

lmbench是一个用于测量系统性能的工具，主要关注延迟和带宽等指标。能够测试包括文档读写、内存操作、进程创建销毁开销、网络等性能。

##### 测试执行过程

lmbench依赖于libtripc库，需要手动编译安装。下载地址为：https://onboardcloud.dl.sourceforge.net/project/libtirpc/libtirpc/1.3.6/libtirpc-1.3.6.tar.bz2?viasf=1

```bash
tar -xf libtirpc-1.3.6.tar.bz2
cd libtirpc-1.3.6
./configure --host=riscv64-unknown-linux-gnu --prefix=/usr/local/ --disable-gssapi
make -j$(nproc)
make install
```

下载lmbench源码：

采用的lmbench版本为3.0-a9：

```bash
tar -xf lmbench-3.0-a9.tgz
git clone https://github.com/twd2/lmbench.git --depth=1
cd lmbench
```

应用以下补丁，以在riscv上编译运行：

```diff
diff --git a/scripts/compiler b/scripts/compiler
index fb563f5..deaa7f0 100755
--- a/scripts/compiler
+++ b/scripts/compiler
@@ -1,6 +1,6 @@
 #!/bin/sh

-echo riscv64-unknown-linux-gnu-gcc
+echo gcc
 exit 0

 if [ "X$CC" != "X" ] && echo "$CC" | grep '`' > /dev/null
diff --git a/src/Makefile b/src/Makefile
index a45f27d..12d6adf 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -58,7 +58,7 @@ SAMPLES=lmbench/Results/aix/rs6000 lmbench/Results/hpux/snake \
        lmbench/Results/irix/indigo2 lmbench/Results/linux/pentium \
        lmbench/Results/osf1/alpha lmbench/Results/solaris/ss20*

-COMPILE=$(CC) $(CFLAGS) -Wall -O2 -ffunction-sections -Wl,--gc-sections -s -static -I$(RISCV)/../sysroot/usr/include/tirpc $(CPPFLAGS) $(LDFLAGS)
+COMPILE=$(CC) $(CFLAGS) -Wall -O2 -ffunction-sections -Wl,--gc-sections -s -static -I/usr/local/include/tirpc $(CPPFLAGS) $(LDFLAGS)

 INCS = bench.h lib_mem.h lib_tcp.h lib_udp.h stats.h timing.h

```

编译测试工具：

```bash
make -j$(nproc)
```

执行测试：

```bash
make results
```

其中，MB参数为4096m，其余参数均为默认值，不上传测试结果。

#### tinymembench

tinymembench是一个简单的内存基准测试程序，主要用于测量顺序内存访问的峰值带宽和随机内存访问的延迟。

##### 测试执行过程

下载tinymembench源码：

```bash
git clone https://github.com/nuumio/tinymembench.git --depth=1
cd tinymembench
```

编译测试工具：

```bash
CFLAGS="-O2" make
./tinymembench
```

##### 测试结果

以下截取了部分测试结果，完整结果请查看 [tinymembench.md](./tinymembench.md) 文件。

```log
==========================================================================
== Memory bandwidth tests                                               ==
==========================================================================

 C copy backwards                                 :   3636.8 MB/s (10, 29.4%)
 C copy backwards (32 byte blocks)                :   1298.6 MB/s (10, 0.2%)
 C copy backwards (64 byte blocks)                :   1171.7 MB/s (10, 0.5%)
 C copy                                           :   2971.3 MB/s (3)
 C copy prefetched (32 bytes step)                :   2973.8 MB/s (3)
 C copy prefetched (64 bytes step)                :   2973.4 MB/s (3)
 C 2-pass copy                                    :   2754.1 MB/s (3)
 C 2-pass copy prefetched (32 bytes step)         :   2762.2 MB/s (3)
 C 2-pass copy prefetched (64 bytes step)         :   2762.1 MB/s (3)
 C scan 8                                         :    664.1 MB/s (3)
 C scan 16                                        :    996.2 MB/s (10, 0.2%)
 C scan 32                                        :   1991.7 MB/s (3)
 C scan 64                                        :   5269.0 MB/s (3)
 C fill                                           :   6226.7 MB/s (10, 0.3%)
 C fill (shuffle within 16 byte blocks)           :   6256.2 MB/s (10, 0.2%)
 C fill (shuffle within 32 byte blocks)           :   1399.6 MB/s (3)
 C fill (shuffle within 64 byte blocks)           :   1399.7 MB/s (3)
 ---
 libc memcpy copy                                 :   2979.6 MB/s (3)
 libc memchr scan                                 :   4958.8 MB/s (10, 0.1%)
 libc memset fill                                 :   6211.3 MB/s (10, 0.3%)

==========================================================================
== Memory latency test                                                  ==
==========================================================================

block size : single random read / dual random read, [MADV_NOHUGEPAGE]
    131072 :    7.9 ns          /    12.2 ns 
    524288 :   13.8 ns          /    17.3 ns 
   2097152 :   62.3 ns          /    94.4 ns 
   8388608 :  124.6 ns          /   166.3 ns 
  33554432 :  178.9 ns          /   224.6 ns 
  67108864 :  202.0 ns          /   250.5 ns 

block size : single random read / dual random read, [MADV_HUGEPAGE]
    131072 :    9.2 ns          /    14.1 ns 
    524288 :   16.3 ns          /    20.9 ns 
   2097152 :   61.5 ns          /    91.3 ns 
   8388608 :   96.1 ns          /   125.2 ns 
  33554432 :  142.5 ns          /   175.2 ns 
  67108864 :  163.1 ns          /   190.0 ns 
```

对比（RevyOS rv64gc）：
```log
 libc memcpy copy                                 :   4113.0 MB/s (4)
 libc memchr scan                                 :   4016.3 MB/s (10, 0.3%)
 libc memset fill                                 :   4895.6 MB/s (10, 0.2%)
```
对比（RevyOS rv64gc_xtheadba_xtheadbb_xtheadbs_xtheadvector）：
```log
 libc memcpy copy                                 :   4096.6 MB/s (10, 0.9%)
 libc memchr scan                                 :   4007.8 MB/s (3)
 libc memset fill                                 :   4890.7 MB/s (10, 0.2%)
```

#### ramlat

ramlat是一个内存性能测试工具，主要用于测量内存的延迟。

##### 测试执行过程

下载ramspeed源码：

```bash
git clone https://github.com/wtarreau/ramspeed.git --depth=1
cd ramspeed
```

应用以下补丁，以在riscv上编译运行：

```diff
diff --git a/Makefile b/Makefile
index 0c39f20..2e07b5c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 CC         := gcc
-CFLAGS     := -O3 -Wall -fomit-frame-pointer -march=native
+CFLAGS     := -O3 -Wall -fomit-frame-pointer -march=rv64gc
 OBJS       := ramlat rambw ramwalk

 all: $(OBJS)
```

编译测试工具：

```bash
make -j$(nproc) all
```

##### 测试结果

ramlat测试结果：

```log
   size:  1x32  2x32  1x64  2x64 1xPTR 2xPTR 4xPTR 8xPTR
     4k: 2.070 2.078 2.004 2.004 1.503 1.502 2.003 4.008
     8k: 2.067 2.076 2.003 2.004 1.503 1.503 2.003 4.006
    16k: 2.069 2.077 2.004 2.003 1.504 1.503 2.004 4.008
    32k: 2.068 2.068 2.004 2.004 1.503 1.503 2.004 4.008
    64k: 7.981 8.125 7.923 8.062 7.423 7.877 9.271 17.46
   128k: 16.77 16.74 16.68 16.66 16.16 16.13 19.78 37.88
   256k: 17.64 17.62 17.56 17.54 17.05 17.11 20.30 40.76
   512k: 17.69 17.62 17.58 17.56 17.06 17.17 20.79 40.61
  1024k: 41.51 41.76 42.44 41.99 42.06 42.60 45.51 65.33
  2048k: 83.82 79.85 79.50 79.33 78.88 79.26 82.57 107.3
  4096k: 84.85 80.76 79.96 79.49 79.05 79.52 84.05 109.5
  8192k: 102.2 95.88 96.18 94.48 94.16 94.92 107.9 121.2
 16384k: 117.7 109.7 112.9 107.4 111.0 107.5 115.0 140.7

```

#### 7zip

7zip是一个流行的文件压缩工具，我们使用它来测试CPU的压缩和解压缩性能。

##### 测试执行过程

下载7zip源码：

```bash
wget https://www.7-zip.org/a/7z2409-src.tar.xz
tar -xf 7z2409-src.tar.xz
cd CPP/7zip/Bundles/Alone2
```

编译测试工具：

```bash
make -f makefile.gcc -j$(nproc)
```

执行测试：

```bash
./7zz b -mmt=x
```

使用`-mmt=x`参数表示使用x个线程进行压缩和解压缩。

##### 测试结果

32线程压缩和解压缩测试结果如下：

```log
                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS
Avr:     22749  2270   1048  23753  |     527466  2922   1561  45827
Tot:            2596   1304  34790
```

对比RevyOS上rv64gc结果为：

```log
Avr:     33435  2467   1426  35116  |     641853  3058   1827  55888
Tot:            2763   1627  45502
```

添加自定义指令集扩展结果为：

```log
Avr:     34903  2489   1473  36589  |     641116  3027   1845  55837
Tot:            2758   1659  46213
```

64线程压缩和解压缩测试结果如下：


```log
                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS
Avr:     47815  4876    999  49377  |     965408  5698   1464  83863
Tot:            5287   1232  66620
```


对比RevyOS上rv64gc结果为：

```log
Avr:     50664  5048   1052  53178  |    1193881  5786   1796 103945
Tot:            5417   1424  78561
```

添加自定义指令集扩展结果为：

```log
Avr:     54183  5059   1122  56800  |    1203899  5776   1815 104840
Tot:            5417   1469  80820
```

#### openssl

openssl是一个广泛使用的加密库，我们使用它来测试加密和解密性能。

##### 测试执行过程

下载openssl源码：

```bash
git clone https://github.com/openssl/openssl.git --depth=1
cd openssl
```

编译测试工具：

```bash
./config --prefix=/usr/local/ --openssldir=/usr/local/ssl -march=rv64gc -O2
make -j$(nproc)
make install
```

我们需要覆盖默认的ld library路径，以便使用新编译的openssl：

```bash
LD_LIBRARY_PATH=/usr/local/lib/
```

##### 执行测试：

```bash
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp sha1
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp sha256
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp sha512
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp md5
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp aes-128-cbc
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp aes-192-cbc
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp aes-256-cbc
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp aes-128-gcm
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp aes-192-gcm
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp aes-256-gcm
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp chacha20
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed -evp chacha20-poly1305
```

```log
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
sha1             13698.58k    40556.37k    90008.66k   129229.14k   147928.41k   149877.98k
sha256            8213.43k    22229.53k    46069.30k    62865.72k    69659.40k    69914.20k
sha512            7918.88k    31872.13k    58199.72k    89169.85k   105106.09k   106753.54k
md5              14313.42k    46538.18k   123885.59k   207725.23k   262511.13k   266283.69k
AES-128-CBC      51971.86k    67262.05k    73644.44k    75122.01k    75996.55k    75777.37k
AES-192-CBC      46220.75k    57790.27k    62419.39k    63442.26k    63810.22k    64045.55k
AES-256-CBC      41431.81k    50597.50k    54057.70k    54630.06k    55075.45k    54993.25k
AES-128-GCM       8381.08k    21051.26k    34420.61k    40600.23k    43147.26k    43491.57k
AES-192-GCM       8299.17k    20085.62k    31654.06k    36966.74k    38828.44k    39239.68k
AES-256-GCM       7378.20k    18579.26k    29090.93k    33767.08k    35596.97k    35880.41k
ChaCha20         60415.17k    85572.03k    93572.71k    95793.83k    96589.14k    96999.86k
ChaCha20-Poly1305    44534.93k    66472.30k    74065.15k    76910.28k    77701.12k    77359.79k
```

对比（rv64gc）：
```log
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
sha1             14715.19k    43305.51k    95713.45k   137474.91k   156762.11k   158067.37k
sha256            9785.12k    25138.39k    49005.06k    63851.18k    69855.91k    70571.75k
sha512            8242.39k    32514.65k    58994.01k    90284.61k   106526.04k   108002.45k
md5              16478.57k    52168.64k   131975.25k   216217.94k   265917.78k   270752.45k
AES-128-CBC      54639.65k    67924.18k    73383.00k    75196.87k    75388.25k    75656.82k
AES-192-CBC      46708.82k    57622.27k    62262.28k    63203.33k    63567.19k    63602.69k
AES-256-CBC      43271.72k    50818.86k    53845.67k    54644.39k    55083.67k    54880.94k
AES-128-GCM      36843.88k    41304.40k    43178.92k    43646.63k    44059.31k    44111.19k
AES-192-GCM      33730.58k    37634.20k    39094.36k    39522.98k    39712.09k    39753.05k
AES-256-GCM      30927.22k    34294.39k    35563.95k    35907.58k    36118.53k    36148.57k
ChaCha20         63600.14k    92609.24k   105709.68k   109680.30k   111427.58k   111394.82k
ChaCha20-Poly1305    48910.67k    73122.24k    82873.45k    86654.29k    87820.97k    87627.09k
```

对比（rv64gc_xtheadxxxxx）：
```log
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 bytes  16384 bytes
sha1             16365.82k    50968.09k   122345.56k   189538.65k   223548.76k   227366.23k
sha256            9767.78k    25409.30k    49302.02k    64379.56k    70878.61k    71128.41k
sha512           10326.97k    41281.73k    80405.25k   127396.86k   153765.76k   155811.84k
md5              17618.20k    56878.83k   149152.68k   255215.05k   318849.02k   324064.60k
AES-128-CBC      53243.55k    67398.61k    73412.61k    75038.04k    75415.55k    75333.63k
AES-192-CBC      47054.55k    56588.69k    62404.92k    63268.18k    63599.96k    63586.30k
AES-256-CBC      42096.33k    50817.92k    53871.62k    54899.07k    54951.94k    54930.09k
AES-128-GCM      37494.08k    42125.27k    44378.50k    44767.23k    45212.17k    45099.69k
AES-192-GCM      34532.09k    38455.72k    39900.59k    40309.76k    40544.94k    40588.63k
AES-256-GCM      31552.39k    34636.41k    35899.08k    36201.47k    36823.04k    36948.93k
ChaCha20         77960.24k   125447.47k   143106.23k   149666.47k   151423.66k   151360.85k
ChaCha20-Poly1305    55587.54k    89953.41k   103054.47k   108760.75k   110714.88k   109909.33k
```

可以看到，新版本的GCC及开启附加指令集扩展后，openssl的性能有了明显提升。


### 功能测试结果

#### LTP Posix兼容性测试

该部分测试为LTP中的open posix测试套，主要测试POSIX标准的兼容性。

该部分测试认为通过率大于等于97%即为通过。

##### 测试执行过程

```bash
cd ltp/testcases/open_posix_testsuite
make all
make test | tee test_log.txt
```

通过以下命令获取测试结果：

```bash
grep PASS test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print "Total PASS: " sum}'
grep FAIL test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print "Total FAIL: " sum}'
grep "PASS\|FAIL" test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print "Total: " sum}'
echo "Success rate: " $(grep PASS test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print sum}') / $(grep "PASS\|FAIL" test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print sum}') \* 100 "%"
```

##### 测试结果

```log
Total PASS: 1690
Total FAIL: 46
Total: 1736
Success rate: 97.35 %
```

该部分测试通过率为97.35%，符合通过标准。

#### LTP 主要测试部分

该部分测试为LTP中的主要测试套，主要测试Linux内核的基本功能。

##### 测试执行过程

安装LTP测试套件：

```bash
git clone https://github.com/linux-test-project/ltp.git --depth=1
cd ltp
make autotools
./configure
make -j$(nproc)
make install
```

执行测试：

```bash
cd /opt/ltp
./runltp -x 16 | tee ltp_run_log.txt
```

由于采用并行测试，部分测试失败可能为假。因此对所有未通过的测试，手动重新运行：

```bash
./runltp -s <test_name>
```

##### 测试结果

以下测试未通过：

```bash
grep -ir fail results/LTP*.log
```

```bash
bpf_prog05                                         FAIL       2    
cve-2021-3444                                      FAIL       2    
bpf_prog06                                         FAIL       2    
cve-2021-4204                                      FAIL       2    
bpf_prog07                                         FAIL       2    
cve-2022-23222                                     FAIL       2    
bpf_prog04                                         FAIL       2    
cve-2018-18445                                     FAIL       2    
connect02                                          FAIL       2    
cve-2018-9568                                      FAIL       2    
close_range01                                      FAIL       2    
fsconfig03                                         FAIL       2    
cve-2022-0185                                      FAIL       2    
zram01                                             FAIL       2    
setsockopt05                                       FAIL       2    
cve-2017-1000112                                   FAIL       2    
setsockopt06                                       FAIL       2    
cve-2016-8655                                      FAIL       2    
setsockopt10                                       FAIL       2    
cve-2023-0461                                      FAIL       2    
setsockopt09                                       FAIL       2    
cve-2021-22600                                     FAIL       2    
setsockopt08                                       FAIL       2    
cve-2021-22555                                     FAIL       2    
ioctl_fiemap01                                     FAIL       1    
wait403                                            FAIL       2    
cve-2019-8912                                      FAIL       2    
af_alg07                                           FAIL       2    
mount07                                            FAIL       4    
cn_pec_sh                                          FAIL       2    
lock_torture                                       FAIL       1    
madvise06                                          FAIL       2    
cve-2023-0461                                      FAIL       2    
cve-2023-31248                                     FAIL       2    
cve-2022-0185                                      FAIL       2    
cve-2022-4378                                      FAIL       2    
pselect01_64                                       FAIL       1    
ksm03_1                                            FAIL       3    
ksm03                                              FAIL       2    
sendto03                                           FAIL       2    
cve-2020-14386                                     FAIL       2    
sendmsg03                                          FAIL       2    
cve-2017-17712                                     FAIL       2    
fanotify13                                         FAIL       1    
cve-2022-23222                                     FAIL       2    
timerfd_settime02                                  FAIL       2    
cve-2017-10661                                     FAIL       2    
overcommit_memory04                                FAIL       1    
overcommit_memory03                                FAIL       1    
```
以上测试均至少运行两次，且均未通过。
共95个测试未通过。

与RevyOS上rv64gc结果对比，以上测试中，RevyOS上未通过测试共14个。
