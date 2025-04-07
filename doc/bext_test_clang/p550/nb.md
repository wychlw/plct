coremark(run1.log):
```
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 14839
Total time (secs): 14.839000
Iterations/Sec   : 7412.898443
Iterations       : 110000
Compiler version : Debian Clang 19.1.7 (1)
Compiler flags   : -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt
Memory location  : Please put data memory location here
                        (e.g. code in flash, data on heap etc)
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0x33ff
Correct operation validated. See README.md for run and reporting rules.
CoreMark 1.0 : 7412.898443 / Debian Clang 19.1.7 (1) -O2 -march=rv64gc -DPERFORMANCE_RUN=1  -lrt / Heap
```

coremark-pro:
```
WORKLOAD RESULTS TABLE

                                                 MultiCore SingleCore           
Workload Name                                     (iter/s)   (iter/s)    Scaling
----------------------------------------------- ---------- ---------- ----------
cjpeg-rose7-preset                                  303.03      81.97       3.70
core                                                  1.35       0.36       3.75
linear_alg-mid-100x100-sp                           337.84      87.41       3.87
loops-all-mid-10k-sp                                  9.00       2.37       3.80
nnet_test                                            12.94       3.89       3.33
parser-125k                                          54.79      14.71       3.72
radix2-big-64k                                     1079.91     355.11       3.04
sha-test                                            285.71      86.21       3.31
zip-test                                            210.53      55.56       3.79

MARK RESULTS TABLE

Mark Name                                        MultiCore SingleCore    Scaling
----------------------------------------------- ---------- ---------- ----------
CoreMark-PRO                                       8373.08    2339.70       3.58
```

unix-bench:
```
========================================================================
   BYTE UNIX Benchmarks (Version 5.1.3)

   System: rockos-eswin: GNU/Linux
   OS: GNU/Linux -- 6.6.83-win2030 -- #2025.03.26.03.10+5d8e55ae6 SMP Wed Mar 26 03:22:16 UTC 2025
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   20:05:36 up 5 days,  1:26,  5 users,  load average: 1.10, 0.95, 0.56; runlevel 2025-04-02

------------------------------------------------------------------------
Benchmark Run: Mon Apr 07 2025 20:05:36 - 20:33:35
4 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables        3642851.0 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     1189.1 MWIPS (9.9 s, 7 samples)
Execl Throughput                               1667.2 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        288996.4 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          101989.8 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        433094.1 KBps  (30.0 s, 2 samples)
Pipe Throughput                              542252.3 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  55344.7 lps   (10.0 s, 7 samples)
Process Creation                               3270.0 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   3766.1 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1223.2 lpm   (60.0 s, 2 samples)
System Call Overhead                         792169.6 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    3642851.0    312.2
Double-Precision Whetstone                       55.0       1189.1    216.2
Execl Throughput                                 43.0       1667.2    387.7
File Copy 1024 bufsize 2000 maxblocks          3960.0     288996.4    729.8
File Copy 256 bufsize 500 maxblocks            1655.0     101989.8    616.3
File Copy 4096 bufsize 8000 maxblocks          5800.0     433094.1    746.7
Pipe Throughput                               12440.0     542252.3    435.9
Pipe-based Context Switching                   4000.0      55344.7    138.4
Process Creation                                126.0       3270.0    259.5
Shell Scripts (1 concurrent)                     42.4       3766.1    888.2
Shell Scripts (8 concurrent)                      6.0       1223.2   2038.7
System Call Overhead                          15000.0     792169.6    528.1
                                                                   ========
System Benchmarks Index Score                                         474.9

------------------------------------------------------------------------
Benchmark Run: Mon Apr 07 2025 20:33:35 - 21:01:37
4 CPUs in system; running 4 parallel copies of tests

Dhrystone 2 using register variables       14261979.3 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     4691.9 MWIPS (10.0 s, 7 samples)
Execl Throughput                               5965.1 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        911664.2 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          376453.1 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       1531300.2 KBps  (30.0 s, 2 samples)
Pipe Throughput                             2138639.6 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 321813.7 lps   (10.0 s, 7 samples)
Process Creation                              11015.9 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   9479.3 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   1224.2 lpm   (60.1 s, 2 samples)
System Call Overhead                        3121575.6 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   14261979.3   1222.1
Double-Precision Whetstone                       55.0       4691.9    853.1
Execl Throughput                                 43.0       5965.1   1387.2
File Copy 1024 bufsize 2000 maxblocks          3960.0     911664.2   2302.2
File Copy 256 bufsize 500 maxblocks            1655.0     376453.1   2274.6
File Copy 4096 bufsize 8000 maxblocks          5800.0    1531300.2   2640.2
Pipe Throughput                               12440.0    2138639.6   1719.2
Pipe-based Context Switching                   4000.0     321813.7    804.5
Process Creation                                126.0      11015.9    874.3
Shell Scripts (1 concurrent)                     42.4       9479.3   2235.7
Shell Scripts (8 concurrent)                      6.0       1224.2   2040.4
System Call Overhead                          15000.0    3121575.6   2081.1
                                                                   ========
System Benchmarks Index Score                                        1573.0
```
