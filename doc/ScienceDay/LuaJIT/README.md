# LuaJIT + Love 环境

## 环境信息

系统：RevyOS
工具链：T-Head GCC&G++

## 安装 Lua 与 LuaJIT

### 搭建开发环境

```bash
sudo sed -i '1ideb https://mirror.iscas.ac.cn/revyos/revyos-c910v/ revyos-c910v main' /etc/apt/sources.list
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential gcc g++
sudo apt autoremove --purge
```

### 安装程序

```bash
git clone https://github.com/plctlab/LuaJIT.git
make -j$(nproc) PREFIX=/
sudo make -j$(nproc) install PREFIX=/
```

## 安装 Love 框架

### 编译安装

```bash
git clone https://github.com/love2d/love.git
./platform/unix/automagic
./configure
make -j$(nproc)
```

## 获取游戏

游戏可以从此处寻找：https://itch.io/games/made-with-love2d

或者 Github 上寻找也可

## 运行游戏

若为打包好的 love 文件：
```bash
./love xxx.love
```

若为一个文件夹：
```bash
./love path/to/folder
```