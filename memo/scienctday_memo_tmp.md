# ip地址分配

## lichee cluster

- openbmc: 192.168.1.60 # cluster-openbmc.
- cluster1: 192.168.1.68 # cluster-main.
- clusters:
  - 1~7: 192.168.1.61~67

## ruyi demo

192.168.1.50 # ruyi-demo.

## qtrvsim

192.168.1.70 # 


env set -f bootcmd 'fdt mmz mmz_nid_0_part_0 0x300000000 0x1000;bootflow scan -lb'; env save

0x0100 15
0x0800 15
0x2000 9.7
0x4000 15
0x10000 9.7