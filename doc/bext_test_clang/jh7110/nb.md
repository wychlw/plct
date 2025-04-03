coremark:
```
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 15813
Total time (secs): 15.813000
Iterations/Sec   : 3794.346424
Iterations       : 60000
Compiler version : Ubuntu Clang 19.1.1 (1ubuntu1~24.04.2)
Compiler flags   : -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt
Memory location  : Please put data memory location here
         (e.g. code in flash, data on heap etc)
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0xbd59
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 3794.346424 / Ubuntu Clang 19.1.1 (1ubuntu1~24.04.2) -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt / Heap
```

coremark-pro:
```
WORKLOAD RESULTS TABLE

                                                 MultiCore SingleCore
Workload Name                                     (iter/s)   (iter/s)    Scaling
----------------------------------------------- ---------- ---------- ----------
cjpeg-rose7-preset                                  138.89      35.97       3.86
core                                                  0.78       0.20       3.90
linear_alg-mid-100x100-sp                            58.69      15.27       3.84
loops-all-mid-10k-sp                                  2.03       0.56       3.62
nnet_test                                             2.31       0.69       3.35
parser-125k                                          28.37       7.69       3.69
radix2-big-64k                                      159.03      54.12       2.94
sha-test                                            113.64      34.25       3.32
zip-test                                             67.80      17.86       3.80

MARK RESULTS TABLE

Mark Name                                        MultiCore SingleCore    Scaling
----------------------------------------------- ---------- ---------- ----------
CoreMark-PRO                                       2488.52     695.67       3.58
```

csibe:
```
Total length of all codes:  3325811
Average length of all codes:  5381.571197411004
Max length of all codes:  220981
0%: 0
10%: 232
20%: 882
30%: 1406
40%: 1872
50%: 2532
60%: 3472
70%: 4954
80%: 7015
90%: 11476
100%:  220981


```

unix-bench:
```
========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: ubuntu: GNU/Linux
   OS: GNU/Linux -- 6.8.0-52-generic -- #53.1-Ubuntu SMP PREEMPT_DYNAMIC Sun Jan 26 04:38:25 UTC 2025
   Machine: riscv64 (riscv64)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   06:24:00 up  4:50,  1 user,  load average: 0.51, 0.82, 1.09; runlevel 2025-04-02

------------------------------------------------------------------------
Benchmark Run: Wed Apr 02 2025 06:24:01 - 06:51:57
4 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        1553832.3 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                      446.0 MWIPS (10.0 s, 7 samples)
Execl Throughput                               1007.7 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        155328.4 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           52038.0 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        289721.3 KBps  (30.0 s, 2 samples)
Pipe Throughput                              332999.2 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  23222.7 lps   (10.0 s, 7 samples)
Process Creation                               1767.4 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   2266.5 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                    728.0 lpm   (60.0 s, 2 samples)
System Call Overhead                         558193.3 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    1553832.3    133.1
Double-Precision Whetstone                       55.0        446.0     81.1
Execl Throughput                                 43.0       1007.7    234.3
File Copy 1024 bufsize 2000 maxblocks          3960.0     155328.4    392.2
File Copy 256 bufsize 500 maxblocks            1655.0      52038.0    314.4
File Copy 4096 bufsize 8000 maxblocks          5800.0     289721.3    499.5
Pipe Throughput                               12440.0     332999.2    267.7
Pipe-based Context Switching                   4000.0      23222.7     58.1
Process Creation                                126.0       1767.4    140.3
Shell Scripts (1 concurrent)                     42.4       2266.5    534.6
Shell Scripts (8 concurrent)                      6.0        728.0   1213.3
System Call Overhead                          15000.0     558193.3    372.1
                                                                   ========
System Benchmarks Index Score                                         256.7

------------------------------------------------------------------------
Benchmark Run: Wed Apr 02 2025 06:51:57 - 07:20:01
4 CPUs in system; running 4 parallel copies of tests

Dhrystone 2 using register variables        6201234.2 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     1779.8 MWIPS (10.0 s, 7 samples)
Execl Throughput                               3514.8 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        583293.7 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          197406.9 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        921999.1 KBps  (30.0 s, 2 samples)
Pipe Throughput                             1337248.6 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 144246.0 lps   (10.0 s, 7 samples)
Process Creation                               7028.1 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   5695.5 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                    740.6 lpm   (60.1 s, 2 samples)
System Call Overhead                        2222869.1 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    6201234.2    531.4
Double-Precision Whetstone                       55.0       1779.8    323.6
Execl Throughput                                 43.0       3514.8    817.4
File Copy 1024 bufsize 2000 maxblocks          3960.0     583293.7   1473.0
File Copy 256 bufsize 500 maxblocks            1655.0     197406.9   1192.8
File Copy 4096 bufsize 8000 maxblocks          5800.0     921999.1   1589.7
Pipe Throughput                               12440.0    1337248.6   1075.0
Pipe-based Context Switching                   4000.0     144246.0    360.6
Process Creation                                126.0       7028.1    557.8
Shell Scripts (1 concurrent)                     42.4       5695.5   1343.3
Shell Scripts (8 concurrent)                      6.0        740.6   1234.3
System Call Overhead                          15000.0    2222869.1   1481.9
                                                                   ========
System Benchmarks Index Score                                         877.5
```
