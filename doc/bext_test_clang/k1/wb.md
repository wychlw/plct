coremark(run1.log):
```
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 13916
Total time (secs): 13.916000
Iterations/Sec   : 4311.583788
Iterations       : 60000
Compiler version : Bianbu Clang 19.1.1 (1ubuntu1~24.04.2bb1)
Compiler flags   : -O2 -march=rv64gc_zba_zbb_zbc_zbs -DPERFORMANCE_RUN=1  -lrt
Memory location  : Please put data memory location here
         (e.g. code in flash, data on heap etc)
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0xbd59
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 4311.583788 / Bianbu Clang 19.1.1 (1ubuntu1~24.04.2bb1) -O2 -march=rv64gc_zba_zbb_zbc_zbs -DPERFORMANCE_RUN=1  -lrt / Heap
```

coremark-pro:
```
WORKLOAD RESULTS TABLE

                                                 MultiCore SingleCore           
Workload Name                                     (iter/s)   (iter/s)    Scaling
----------------------------------------------- ---------- ---------- ----------
cjpeg-rose7-preset                                   46.08      11.95       3.86
core                                                  0.29       0.07       4.14
linear_alg-mid-100x100-sp                            22.93       5.99       3.83
loops-all-mid-10k-sp                                  1.14       0.31       3.68
nnet_test                                             0.85       0.26       3.27
parser-125k                                          10.47       4.35       2.41
radix2-big-64k                                       77.77      24.65       3.15
sha-test                                             64.10      19.31       3.32
zip-test                                             30.77       7.87       3.91

MARK RESULTS TABLE

Mark Name                                        MultiCore SingleCore    Scaling
----------------------------------------------- ---------- ---------- ----------
CoreMark-PRO                                       1059.61     305.59       3.47
```

csibe:
```
Total length of all codes:  3297953
Average length of all codes:  5336.493527508091
Max length of all codes:  219671
0%: 0
10%: 232
20%: 878
30%: 1393
40%: 1848
50%: 2500
60%: 3448
70%: 4887
80%: 6991
90%: 11378
100%:  219671
```

unix-bench:
```
========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: k1: GNU/Linux
   OS: GNU/Linux -- 6.6.63 -- #2.1.0.2 SMP PREEMPT Fri Jan 24 03:39:48 UTC 2025
   Machine: riscv64 (riscv64)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   CPU 0: Spacemit(R) X60 (0.0 bogomips)

   CPU 1: Spacemit(R) X60 (0.0 bogomips)

   CPU 2: Spacemit(R) X60 (0.0 bogomips)

   CPU 3: Spacemit(R) X60 (0.0 bogomips)

   CPU 4: Spacemit(R) X60 (0.0 bogomips)

   CPU 5: Spacemit(R) X60 (0.0 bogomips)

   CPU 6: Spacemit(R) X60 (0.0 bogomips)

   CPU 7: Spacemit(R) X60 (0.0 bogomips)

   23:28:30 up  3:04,  1 user,  load average: 2.29, 3.39, 3.37; runlevel Apr

------------------------------------------------------------------------
Benchmark Run: 三 4月 02 2025 23:28:30 - 23:56:42
8 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        1802080.1 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                      643.2 MWIPS (10.0 s, 7 samples)
Execl Throughput                                639.3 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        198752.2 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           61772.3 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        403963.8 KBps  (30.0 s, 2 samples)
Pipe Throughput                              394515.0 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  28528.4 lps   (10.0 s, 7 samples)
Process Creation                               1377.7 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   1923.7 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1042.3 lpm   (60.0 s, 2 samples)
System Call Overhead                         604953.4 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    1802080.1    154.4
Double-Precision Whetstone                       55.0        643.2    117.0
Execl Throughput                                 43.0        639.3    148.7
File Copy 1024 bufsize 2000 maxblocks          3960.0     198752.2    501.9
File Copy 256 bufsize 500 maxblocks            1655.0      61772.3    373.2
File Copy 4096 bufsize 8000 maxblocks          5800.0     403963.8    696.5
Pipe Throughput                               12440.0     394515.0    317.1
Pipe-based Context Switching                   4000.0      28528.4     71.3
Process Creation                                126.0       1377.7    109.3
Shell Scripts (1 concurrent)                     42.4       1923.7    453.7
Shell Scripts (8 concurrent)                      6.0       1042.3   1737.2
System Call Overhead                          15000.0     604953.4    403.3
                                                                   ========
System Benchmarks Index Score                                         284.0

------------------------------------------------------------------------
Benchmark Run: 三 4月 02 2025 23:56:42 - 00:25:01
8 CPUs in system; running 8 parallel copies of tests

Dhrystone 2 using register variables       14370030.8 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     5114.9 MWIPS (10.0 s, 7 samples)
Execl Throughput                               3622.0 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks       1497981.7 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          481422.1 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       2249192.1 KBps  (30.0 s, 2 samples)
Pipe Throughput                             3146961.1 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 212260.4 lps   (10.0 s, 7 samples)
Process Creation                               6739.6 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   8567.9 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1131.2 lpm   (60.3 s, 2 samples)
System Call Overhead                        4800620.3 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   14370030.8   1231.4
Double-Precision Whetstone                       55.0       5114.9    930.0
Execl Throughput                                 43.0       3622.0    842.3
File Copy 1024 bufsize 2000 maxblocks          3960.0    1497981.7   3782.8
File Copy 256 bufsize 500 maxblocks            1655.0     481422.1   2908.9
File Copy 4096 bufsize 8000 maxblocks          5800.0    2249192.1   3877.9
Pipe Throughput                               12440.0    3146961.1   2529.7
Pipe-based Context Switching                   4000.0     212260.4    530.7
Process Creation                                126.0       6739.6    534.9
Shell Scripts (1 concurrent)                     42.4       8567.9   2020.7
Shell Scripts (8 concurrent)                      6.0       1131.2   1885.3
System Call Overhead                          15000.0    4800620.3   3200.4
                                                                   ========
System Benchmarks Index Score                                        1633.3
```
