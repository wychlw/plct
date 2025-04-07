coremark(run1.log):
```
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 13916
Total time (secs): 13.916000
Iterations/Sec   : 7904.570279
Iterations       : 110000
Compiler version : Debian Clang 19.1.7 (1)
Compiler flags   : -O2 -march=rv64gc_zba_zbb -DPERFORMANCE_RUN=1  -lrt
Memory location  : Please put data memory location here
                        (e.g. code in flash, data on heap etc)
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0x33ff
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 7904.570279 / Debian Clang 19.1.7 (1) -O2 -march=rv64gc_zba_zbb -DPERFORMANCE_RUN=1  -lrt / Heap
```

coremark-pro:
```
WORKLOAD RESULTS TABLE

                                                 MultiCore SingleCore           
Workload Name                                     (iter/s)   (iter/s)    Scaling
----------------------------------------------- ---------- ---------- ----------
cjpeg-rose7-preset                                  333.33      85.47       3.90
core                                                  1.46       0.38       3.84
linear_alg-mid-100x100-sp                           342.47      89.29       3.84
loops-all-mid-10k-sp                                  9.11       2.39       3.81
nnet_test                                            12.97       3.90       3.33
parser-125k                                          56.34      14.49       3.89
radix2-big-64k                                     1068.38     352.86       3.03
sha-test                                            434.78     129.87       3.35
zip-test                                            222.22      58.82       3.78

MARK RESULTS TABLE

Mark Name                                        MultiCore SingleCore    Scaling
----------------------------------------------- ---------- ---------- ----------
CoreMark-PRO                                       9043.05    2493.64       3.63
```

unix-bench:
```
========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: rockos-eswin: GNU/Linux
   OS: GNU/Linux -- 6.6.83-win2030 -- #2025.03.26.03.10+5d8e55ae6 SMP Wed Mar 26 03:22:16 UTC 2025
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   17:49:10 up 4 days, 23:09,  4 users,  load average: 0.49, 0.78, 0.51; runlevel 2025-04-02

------------------------------------------------------------------------
Benchmark Run: Mon Apr 07 2025 17:49:10 - 18:17:09
4 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        3555073.4 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     1192.1 MWIPS (10.0 s, 7 samples)
Execl Throughput                               1670.1 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        290390.5 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          101806.3 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        434899.5 KBps  (30.0 s, 2 samples)
Pipe Throughput                              542827.9 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  55522.2 lps   (10.0 s, 7 samples)
Process Creation                               3325.8 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   3773.6 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1223.7 lpm   (60.0 s, 2 samples)
System Call Overhead                         792448.4 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    3555073.4    304.6
Double-Precision Whetstone                       55.0       1192.1    216.8
Execl Throughput                                 43.0       1670.1    388.4
File Copy 1024 bufsize 2000 maxblocks          3960.0     290390.5    733.3
File Copy 256 bufsize 500 maxblocks            1655.0     101806.3    615.1
File Copy 4096 bufsize 8000 maxblocks          5800.0     434899.5    749.8
Pipe Throughput                               12440.0     542827.9    436.4
Pipe-based Context Switching                   4000.0      55522.2    138.8
Process Creation                                126.0       3325.8    264.0
Shell Scripts (1 concurrent)                     42.4       3773.6    890.0
Shell Scripts (8 concurrent)                      6.0       1223.7   2039.5
System Call Overhead                          15000.0     792448.4    528.3
                                                                   ========
System Benchmarks Index Score                                         475.3

------------------------------------------------------------------------
Benchmark Run: Mon Apr 07 2025 18:17:09 - 18:45:10
4 CPUs in system; running 4 parallel copies of tests

Dhrystone 2 using register variables       13917105.9 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     4705.4 MWIPS (9.9 s, 7 samples)
Execl Throughput                               5944.9 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        916050.1 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          378982.9 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       1536253.2 KBps  (30.0 s, 2 samples)
Pipe Throughput                             2142119.6 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 317304.7 lps   (10.0 s, 7 samples)
Process Creation                              11104.5 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   9474.0 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1226.8 lpm   (60.1 s, 2 samples)
System Call Overhead                        3118249.1 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   13917105.9   1192.6
Double-Precision Whetstone                       55.0       4705.4    855.5
Execl Throughput                                 43.0       5944.9   1382.5
File Copy 1024 bufsize 2000 maxblocks          3960.0     916050.1   2313.3
File Copy 256 bufsize 500 maxblocks            1655.0     378982.9   2289.9
File Copy 4096 bufsize 8000 maxblocks          5800.0    1536253.2   2648.7
Pipe Throughput                               12440.0    2142119.6   1722.0
Pipe-based Context Switching                   4000.0     317304.7    793.3
Process Creation                                126.0      11104.5    881.3
Shell Scripts (1 concurrent)                     42.4       9474.0   2234.4
Shell Scripts (8 concurrent)                      6.0       1226.8   2044.7
System Call Overhead                          15000.0    3118249.1   2078.8
                                                                   ========
System Benchmarks Index Score                                        1571.2
```
