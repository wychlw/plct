coremark(run1.log):
```
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 14109
Total time (secs): 14.109000
Iterations/Sec   : 4252.604720
Iterations       : 60000
Compiler version : Bianbu Clang 19.1.1 (1ubuntu1~24.04.2bb1)
Compiler flags   : -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt
Memory location  : Please put data memory location here
         (e.g. code in flash, data on heap etc)
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0xbd59
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 4252.604720 / Bianbu Clang 19.1.1 (1ubuntu1~24.04.2bb1) -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt / Heap
```

coremark-pro:
```
WORKLOAD RESULTS TABLE

                                                 MultiCore SingleCore
Workload Name                                     (iter/s)   (iter/s)    Scaling
----------------------------------------------- ---------- ---------- ----------
cjpeg-rose7-preset                                  151.52      39.06       3.88
core                                                  0.97       0.25       3.88
linear_alg-mid-100x100-sp                           102.67      26.84       3.83
loops-all-mid-10k-sp                                  2.65       0.78       3.40
nnet_test                                             3.95       1.18       3.35
parser-125k                                          12.74       7.63       1.67
radix2-big-64k                                      107.23      47.04       2.28
sha-test                                            128.21      38.91       3.30
zip-test                                             68.97      18.18       3.79

MARK RESULTS TABLE

Mark Name                                        MultiCore SingleCore    Scaling
----------------------------------------------- ---------- ---------- ----------
CoreMark-PRO                                       2663.13     843.55       3.16
```

csibe:
```
Total length of all codes:  3305763
Average length of all codes:  5349.131067961165
Max length of all codes:  220981
0%: 0
10%: 232
20%: 878
30%: 1395
40%: 1848
50%: 2515
60%: 3462
70%: 4922
80%: 6991
90%: 11382
100%:  220981
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

   01:30:20 up  5:06,  1 user,  load average: 2.54, 2.86, 3.14; runlevel Apr

------------------------------------------------------------------------
Benchmark Run: 四 4月 03 2025 01:30:20 - 01:58:32
8 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        1785518.9 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                      644.5 MWIPS (10.0 s, 7 samples)
Execl Throughput                                647.2 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        198268.4 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           63866.8 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        392247.7 KBps  (30.0 s, 2 samples)
Pipe Throughput                              399909.2 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  28594.0 lps   (10.0 s, 7 samples)
Process Creation                               1371.1 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   1927.8 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1043.4 lpm   (60.0 s, 2 samples)
System Call Overhead                         604049.7 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    1785518.9    153.0
Double-Precision Whetstone                       55.0        644.5    117.2
Execl Throughput                                 43.0        647.2    150.5
File Copy 1024 bufsize 2000 maxblocks          3960.0     198268.4    500.7
File Copy 256 bufsize 500 maxblocks            1655.0      63866.8    385.9
File Copy 4096 bufsize 8000 maxblocks          5800.0     392247.7    676.3
Pipe Throughput                               12440.0     399909.2    321.5
Pipe-based Context Switching                   4000.0      28594.0     71.5
Process Creation                                126.0       1371.1    108.8
Shell Scripts (1 concurrent)                     42.4       1927.8    454.7
Shell Scripts (8 concurrent)                      6.0       1043.4   1739.1
System Call Overhead                          15000.0     604049.7    402.7
                                                                   ========
System Benchmarks Index Score                                         284.5

------------------------------------------------------------------------
Benchmark Run: 四 4月 03 2025 01:58:32 - 02:26:51
8 CPUs in system; running 8 parallel copies of tests

Dhrystone 2 using register variables       14238643.8 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     5140.9 MWIPS (10.0 s, 7 samples)
Execl Throughput                               3607.7 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks       1463703.6 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          484456.5 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       2212291.4 KBps  (30.0 s, 2 samples)
Pipe Throughput                             3160350.9 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 234444.7 lps   (10.0 s, 7 samples)
Process Creation                               6449.3 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   8426.2 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1105.2 lpm   (60.2 s, 2 samples)
System Call Overhead                        4814973.2 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   14238643.8   1220.1
Double-Precision Whetstone                       55.0       5140.9    934.7
Execl Throughput                                 43.0       3607.7    839.0
File Copy 1024 bufsize 2000 maxblocks          3960.0    1463703.6   3696.2
File Copy 256 bufsize 500 maxblocks            1655.0     484456.5   2927.2
File Copy 4096 bufsize 8000 maxblocks          5800.0    2212291.4   3814.3
Pipe Throughput                               12440.0    3160350.9   2540.5
Pipe-based Context Switching                   4000.0     234444.7    586.1
Process Creation                                126.0       6449.3    511.8
Shell Scripts (1 concurrent)                     42.4       8426.2   1987.3
Shell Scripts (8 concurrent)                      6.0       1105.2   1842.0
System Call Overhead                          15000.0    4814973.2   3210.0
                                                                   ========
System Benchmarks Index Score                                        1630.7
```
