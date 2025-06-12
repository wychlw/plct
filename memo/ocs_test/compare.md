# Unix Bench

## rv64gc

```log
========================================================================
   BYTE UNIX Benchmarks (Version 6.0.0)

   System: revyos-upstream: GNU/Linux
   OS: GNU/Linux -- 6.15.1-pioneer -- #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   21:25:28 up 7 min,  4 users,  load average: 0.00, 0.05, 0.04; runlevel 

------------------------------------------------------------------------
Benchmark Run: Thu Jun 12 2025 21:25:28 - 21:53:42
64 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables       13903679.2 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     2872.9 MWIPS (10.0 s, 7 samples)
Execl Throughput                                639.0 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        209070.4 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           57204.4 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        663817.8 KBps  (30.0 s, 2 samples)
Pipe Throughput                              478303.1 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  13969.8 lps   (10.0 s, 7 samples)
Process Creation                               1203.4 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   2616.3 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   2086.1 lpm   (60.0 s, 2 samples)
System Call Overhead                         409011.5 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   13903679.2   1191.4
Double-Precision Whetstone                       55.0       2872.9    522.3
Execl Throughput                                 43.0        639.0    148.6
File Copy 1024 bufsize 2000 maxblocks          3960.0     209070.4    528.0
File Copy 256 bufsize 500 maxblocks            1655.0      57204.4    345.6
File Copy 4096 bufsize 8000 maxblocks          5800.0     663817.8   1144.5
Pipe Throughput                               12440.0     478303.1    384.5
Pipe-based Context Switching                   4000.0      13969.8     34.9
Process Creation                                126.0       1203.4     95.5
Shell Scripts (1 concurrent)                     42.4       2616.3    617.0
Shell Scripts (8 concurrent)                      6.0       2086.1   3476.8
System Call Overhead                          15000.0     409011.5    272.7
                                                                   ========
System Benchmarks Index Score                                         395.1
```

```log
========================================================================
   BYTE UNIX Benchmarks (Version 6.0.0)

   System: revyos-upstream: GNU/Linux
   OS: GNU/Linux -- 6.15.1-pioneer -- #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   21:55:22 up 37 min,  4 users,  load average: 1.98, 4.04, 2.38; runlevel 

------------------------------------------------------------------------
Benchmark Run: Thu Jun 12 2025 21:55:22 - 22:23:50
64 CPUs in system; running 32 parallel copies of tests

Dhrystone 2 using register variables      444061513.4 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                    91791.3 MWIPS (10.0 s, 7 samples)
Execl Throughput                              14846.6 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks       6269884.0 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks         1740672.7 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks      11242804.8 KBps  (30.0 s, 2 samples)
Pipe Throughput                            15034169.1 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                1500763.2 lps   (10.0 s, 7 samples)
Process Creation                              10501.9 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                  52680.7 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   7000.7 lpm   (60.1 s, 2 samples)
System Call Overhead                       12805823.4 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0  444061513.4  38051.5
Double-Precision Whetstone                       55.0      91791.3  16689.3
Execl Throughput                                 43.0      14846.6   3452.7
File Copy 1024 bufsize 2000 maxblocks          3960.0    6269884.0  15833.0
File Copy 256 bufsize 500 maxblocks            1655.0    1740672.7  10517.7
File Copy 4096 bufsize 8000 maxblocks          5800.0   11242804.8  19384.1
Pipe Throughput                               12440.0   15034169.1  12085.3
Pipe-based Context Switching                   4000.0    1500763.2   3751.9
Process Creation                                126.0      10501.9    833.5
Shell Scripts (1 concurrent)                     42.4      52680.7  12424.7
Shell Scripts (8 concurrent)                      6.0       7000.7  11667.9
System Call Overhead                          15000.0   12805823.4   8537.2
                                                                   ========
System Benchmarks Index Score                                        9119.9

```

## rv64gc_xtheadba_xtheadbb_xtheadbs_xtheadvector

```log

========================================================================
   BYTE UNIX Benchmarks (Version 6.0.0)

   System: revyos-upstream: GNU/Linux
   OS: GNU/Linux -- 6.15.1-pioneer -- #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   22:56:49 up  1:39,  4 users,  load average: 2.78, 4.54, 9.11; runlevel 

------------------------------------------------------------------------
Benchmark Run: Thu Jun 12 2025 22:56:49 - 23:25:03
64 CPUs in system; running 1 parallel copy of tests

Dhrystone 2 using register variables       13810865.0 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     2872.7 MWIPS (10.0 s, 7 samples)
Execl Throughput                                633.7 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        208075.0 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           58044.0 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        643488.2 KBps  (30.0 s, 2 samples)
Pipe Throughput                              475823.7 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  12287.4 lps   (10.0 s, 7 samples)
Process Creation                               1185.5 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   2615.2 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   2078.8 lpm   (60.0 s, 2 samples)
System Call Overhead                         411787.9 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0   13810865.0   1183.5
Double-Precision Whetstone                       55.0       2872.7    522.3
Execl Throughput                                 43.0        633.7    147.4
File Copy 1024 bufsize 2000 maxblocks          3960.0     208075.0    525.4
File Copy 256 bufsize 500 maxblocks            1655.0      58044.0    350.7
File Copy 4096 bufsize 8000 maxblocks          5800.0     643488.2   1109.5
Pipe Throughput                               12440.0     475823.7    382.5
Pipe-based Context Switching                   4000.0      12287.4     30.7
Process Creation                                126.0       1185.5     94.1
Shell Scripts (1 concurrent)                     42.4       2615.2    616.8
Shell Scripts (8 concurrent)                      6.0       2078.8   3464.7
System Call Overhead                          15000.0     411787.9    274.5
                                                                   ========
System Benchmarks Index Score                                         389.2
```

```log
========================================================================
   BYTE UNIX Benchmarks (Version 6.0.0)

   System: revyos-upstream: GNU/Linux
   OS: GNU/Linux -- 6.15.1-pioneer -- #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025
   Machine: riscv64 (unknown)
   Language: en_US.utf8 (charmap="ANSI_X3.4-1968", collate="ANSI_X3.4-1968")
   23:25:10 up  2:07,  4 users,  load average: 8.89, 5.60, 4.06; runlevel 

------------------------------------------------------------------------
Benchmark Run: Thu Jun 12 2025 23:25:10 - 23:53:36
64 CPUs in system; running 32 parallel copies of tests

Dhrystone 2 using register variables      441144676.1 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                    91745.8 MWIPS (10.0 s, 7 samples)
Execl Throughput                              14828.6 lps   (29.9 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks       6233825.6 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks         1746820.2 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks      11599403.5 KBps  (30.0 s, 2 samples)
Pipe Throughput                            15003061.0 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                1520248.8 lps   (10.0 s, 7 samples)
Process Creation                              10504.4 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                  52430.9 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   7051.2 lpm   (60.1 s, 2 samples)
System Call Overhead                       12812727.1 lps   (10.0 s, 7 samples)

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0  441144676.1  37801.6
Double-Precision Whetstone                       55.0      91745.8  16681.0
Execl Throughput                                 43.0      14828.6   3448.5
File Copy 1024 bufsize 2000 maxblocks          3960.0    6233825.6  15742.0
File Copy 256 bufsize 500 maxblocks            1655.0    1746820.2  10554.8
File Copy 4096 bufsize 8000 maxblocks          5800.0   11599403.5  19999.0
Pipe Throughput                               12440.0   15003061.0  12060.3
Pipe-based Context Switching                   4000.0    1520248.8   3800.6
Process Creation                                126.0      10504.4    833.7
Shell Scripts (1 concurrent)                     42.4      52430.9  12365.8
Shell Scripts (8 concurrent)                      6.0       7051.2  11752.0
System Call Overhead                          15000.0   12812727.1   8541.8
                                                                   ========
System Benchmarks Index Score                                        9146.4


```

# 7zz

## rv64gc

```log

7-Zip (z) 24.09 (riscv64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-11-29
 64-bit locale=C.UTF-8 Threads:64 OPEN_MAX:1024

 mt=32
Compiler:  ver:14.2.0 GCC 14.2.0
Linux : 6.15.1-pioneer : #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025 : riscv64
PageSize:4KB THP:always hwcap:112D
riscv64

1T CPU Freq (MHz):  1969  1991  1991  1991  1990  1985  1990
16T CPU Freq (MHz): 1587% 1972   1593% 1980  
32T CPU Freq (MHz): 3144% 1948   3165% 1962  

RAM size:  127874 MB,  # CPU hardware threads:  64
RAM usage:   7119 MB,  # Benchmark threads:     32

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      36025  2261   1550  35046  |     675953  3083   1869  57631
23:      31224  2506   1270  31814  |     649538  3065   1833  56194
24:      34810  2548   1469  37429  |     628011  3049   1807  55106
25:      31682  2552   1417  36174  |     613911  3035   1799  54620
----------------------------------  | ------------------------------
Avr:     33435  2467   1426  35116  |     641853  3058   1827  55888
Tot:            2763   1627  45502

```

```log

7-Zip (z) 24.09 (riscv64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-11-29
 64-bit locale=C.UTF-8 Threads:64 OPEN_MAX:1024

 mt=64
Compiler:  ver:14.2.0 GCC 14.2.0
Linux : 6.15.1-pioneer : #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025 : riscv64
PageSize:4KB THP:always hwcap:112D
riscv64

1T CPU Freq (MHz):  1964  1991  1990  1985  1990  1986  1990
32T CPU Freq (MHz): 3143% 1948   3164% 1962  
64T CPU Freq (MHz): 6083% 1880   6238% 1931  

RAM size:  127874 MB,  # CPU hardware threads:  64
RAM usage:  14239 MB,  # Benchmark threads:     64

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      59585  5063   1145  57965  |    1242981  5763   1839 105979
23:      42880  4947    883  43690  |    1230753  5896   1806 106480
24:      50170  5058   1067  53943  |    1195837  5909   1776 104929
25:      50022  5125   1114  57113  |    1105951  5576   1765  98392
----------------------------------  | ------------------------------
Avr:     50664  5048   1052  53178  |    1193881  5786   1796 103945
Tot:            5417   1424  78561

```


## rv64gc_xtheadba_xtheadbb_xtheadbs_xtheadvector

```log
7-Zip (z) 24.09 (riscv64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-11-29
 64-bit locale=C.UTF-8 Threads:64 OPEN_MAX:1024

 mt=32
Compiler:  ver:14.2.0 GCC 14.2.0
Linux : 6.15.1-pioneer : #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025 : riscv64
PageSize:4KB THP:always hwcap:112D
riscv64

1T CPU Freq (MHz):  1967  1990  1991  1991  1989  1990  1990
16T CPU Freq (MHz): 1589% 1969   1594% 1979  
32T CPU Freq (MHz): 3148% 1950   3169% 1964  

RAM size:  127874 MB,  # CPU hardware threads:  64
RAM usage:   7119 MB,  # Benchmark threads:     32

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      40305  2373   1652  39209  |     654397  2962   1884  55793
23:      32963  2519   1333  33586  |     642529  3005   1850  55588
24:      32909  2551   1387  35384  |     658124  3150   1833  57748
25:      33435  2512   1520  38175  |     609415  2993   1812  54220
----------------------------------  | ------------------------------
Avr:     34903  2489   1473  36589  |     641116  3027   1845  55837
Tot:            2758   1659  46213

```

```log

7-Zip (z) 24.09 (riscv64) : Copyright (c) 1999-2024 Igor Pavlov : 2024-11-29
 64-bit locale=C.UTF-8 Threads:64 OPEN_MAX:1024

 mt=64
Compiler:  ver:14.2.0 GCC 14.2.0
Linux : 6.15.1-pioneer : #2025.06.04.17.31+0155156c2 SMP Wed Jun  4 18:35:26 UTC 2025 : riscv64
PageSize:4KB THP:always hwcap:112D
riscv64

1T CPU Freq (MHz):  1966  1988  1988  1987  1990  1990  1990
32T CPU Freq (MHz): 3144% 1948   3165% 1962  
64T CPU Freq (MHz): 6095% 1883   6242% 1932  

RAM size:  127874 MB,  # CPU hardware threads:  64
RAM usage:  14239 MB,  # Benchmark threads:     64

                       Compressing  |                  Decompressing
Dict     Speed Usage    R/U Rating  |      Speed Usage    R/U Rating
         KiB/s     %   MIPS   MIPS  |      KiB/s     %   MIPS   MIPS

22:      62189  5132   1179  60498  |    1226928  5630   1858 104610
23:      51955  4936   1072  52936  |    1236964  5851   1829 107017
24:      50529  5024   1081  54329  |    1219829  5976   1791 107034
25:      52058  5142   1156  59438  |    1131875  5648   1783 100699
----------------------------------  | ------------------------------
Avr:     54183  5059   1122  56800  |    1203899  5776   1815 104840
Tot:            5417   1469  80820

```

## openssl

### rv64gc

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

### rv64gc_xtheadba_xtheadbb_xtheadbs_xtheadvector

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

## LTP

```log
overcommit_memory04                                FAIL       1    
overcommit_memory03                                FAIL       1    
ksm03_1                                            FAIL       2    
ksm03                                              FAIL       2    
ksm03_1                                            FAIL       2    
cve-2023-0461                                      FAIL       2    
cve-2023-0461                                      FAIL       2    
cn_pec_sh                                          FAIL       2    
```

## Posix

```log
Total PASS: 1690
Total FAIL: 46
Total: 1736
Success rate:  97.35 %
```