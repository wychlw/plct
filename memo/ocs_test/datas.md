# Perfs

## Unix Bench

```bash
mkdir unixbench && cd unixbench
wget https://github.com/kdlucas/byte-unixbench/archive/refs/tags/v6.0.0.tar.gz
tar -xf v6.0.0.tar.gz
cd byte-unixbench-6.0.0/UnixBench/
make -j$(nproc)
./Run -c 1
```

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

```bash
./Run -c 32
```

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

## fio

```bash
mkdir fio && cd fio
wget https://github.com/axboe/fio/archive/refs/tags/fio-3.40.tar.gz
tar -xf fio-3.40.tar.gz
cd fio-fio-3.40/
./configure
make -j$(nproc)
```

```bash
disk=\nvme0n1p4
numjobs=10
iodepth=10
mkdir -p /test
for rw in read write randread randwrite randrw;do
    for bs in 4 16 32 64 128 256 512 1024;do
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
```

## STREAM

```bash
mkdir stream && cd stream
git clone https://github.com/jeffhammond/STREAM/ --depth=1
cd STREAM
gcc -fopenmp -O -DSTREAM_ARRAY_SIZE=128000000 stream.c -o fstream128M
```

```bash
export OMP_NUM_THREADS=1
export GOMP_CPU_AFFINITY=0
sync && sysctl -w vm.drop_caches=3
./fstream128M
```

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

```bash
export OMP_NUM_THREADS=`nproc`
export GOMP_CPU_AFFINITY=0-`expr $(nproc) - 1`
sync && sysctl -w vm.drop_caches=3
./fstream128M
```

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

## lmbench

https://onboardcloud.dl.sourceforge.net/project/libtirpc/libtirpc/1.3.6/libtirpc-1.3.6.tar.bz2?viasf=1

https://onboardcloud.dl.sourceforge.net/project/lmbench/development/lmbench-3.0-a9/lmbench-3.0-a9.tgz?viasf=1

```bash
mkdir lmbench && cd lmbench
tar -xf libtirpc-1.3.6.tar.bz2
cd libtirpc-1.3.6
./configure --host=riscv64-unknown-linux-gnu --prefix=/usr/local/ --disable-gssapi
make -j$(nproc)
make install
cd ..

# tar -xf lmbench-3.0-a9.tgz
# cd lmbench-3.0-a9
git clone https://github.com/twd2/lmbench.git --depth=1
cd lmbench
```

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

```info
4096m, others default
```

log: [lmbench.log](./lmbench.log)

## tinymembench

```bash
git clone https://github.com/nuumio/tinymembench.git --depth=1
cd tinymembench
CFLAGS="-O2" make
./tinymembench
```

log: [tinymembench.log](./tinymembench.log)


## ramspeed

```bash
git clone https://github.com/wtarreau/ramspeed.git --depth=1
cd ramspeed
```

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

```bash
make all
```

ramlat:
```bash
./ramlat -b -n
```

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

## 7zip

```bash
mkdir 7zip && cd 7zip
wget https://www.7-zip.org/a/7z2409-src.tar.xz
tar -xf 7z2409-src.tar.xz
cd CPP/7zip/Bundles/Alone2
mv _o/7zz ../../../..
cd ../../../..
```

```bash
./7zz b -mmt=32
```

```log

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      26030  2434   1040  25323  |     654295  3073   1815  55785
23:      22589  1949   1181  23016  |     563791  2998   1627  48776
24:      25726  2580   1072  27661  |     486083  2920   1461  42652
25:      16652  2117    898  19013  |     405697  2696   1339  36095
----------------------------------  | ------------------------------
Avr:     22749  2270   1048  23753  |     527466  2922   1561  45827
Tot:            2596   1304  34790

```

```bash
./7zz b -mmt=64
```

```log

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      66152  5274   1220  64353  |    1218964  6009   1730 103931
23:      56106  5252   1088  57165  |    1022090  5745   1539  88427
24:      42000  4565    989  45158  |     886628  5685   1368  77797
25:      27002  4414    699  30830  |     733949  5353   1220  65297
----------------------------------  | ------------------------------
Avr:     47815  4876    999  49377  |     965408  5698   1464  83863
Tot:            5287   1232  66620

```

## OpenSSL

```bash
git clone https://github.com/openssl/openssl.git --depth=1
cd openssl
./config --prefix=/usr/local/ --openssldir=/usr/local/ssl -march=rv64gc -O2
make -j$(nproc)
make install
```

```bash
LD_LIBRARY_PATH=/usr/local/lib/ openssl speed
```

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


## trinity

```bash
git clone https://github.com/kernelslacker/trinity.git --depth=1
cd trinity
./configure
make -j
make install

trinity -q -C16 | tee trinity_run_log.txt
```

## LTP

```bash
git clone https://github.com/linux-test-project/ltp.git --depth=1
cd ltp
make autotools
./configure
make -j$(nproc)
make install
```

```bash
cd /opt/ltp
./runltp -x 16 | tee ltp_run_log.txt
```

```bash
grep -ir fail results/LTP*.log
```

```bash
grep -ir broken results/LTP*.log
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

### open posix test suite

```bash
cd ltp/testcases/open_posix_testsuite
make all
make test | tee test_log.txt

grep PASS test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print "Total PASS: " sum}'
grep FAIL test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print "Total FAIL: " sum}'
grep "PASS\|FAIL" test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print "Total: " sum}'
echo "Success rate: " $(grep PASS test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print sum}') / $(grep "PASS\|FAIL" test_log.txt | awk '{print $2}' | awk '{sum += $1} END {print sum}') \* 100 "%"
```

```log
Total PASS: 1690
Total FAIL: 46
Total: 1736
Success rate: 97.35 %
```