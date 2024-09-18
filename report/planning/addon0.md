## 自动化测试工具

###  预期目标

实现包括cli、gui在内的，板上自动化刷写、测试、生成log的操作。可通过串口、ssh、VNC、采集卡等方式进行多机交互，并给出相应测试结果。

### 目前进度

基本完成cli部分编写，接入sdwirec允许自动刷写sd卡，可以通过Python脚本产出各类log和报告等。后续考虑继续在cli部分加入通过metadata、实时编写脚本并得到结果等以更加方便测试脚本的编写

相比于之前的自动测试工具具有高度扩展性，支持通过类似管道方式获取和过滤输入输出结果

### 仓库地址

https://github.com/wychlw/autotester

## demo调研

### 预计结果

整理各个常用平台上的可用demo，生成教学文档以便于用户搭建环境和使用

### 目前进度

visionfive2上大部分demo环境搭建文档和教学使用方式搜集完毕
m1s dock开发环境搭建和部分demo整理完毕

### 仓库地址

https://github.com/wychlw/plct/tree/main/doc/vf2_demo
https://github.com/wychlw/plct/tree/main/doc/m1s_dock_demo



