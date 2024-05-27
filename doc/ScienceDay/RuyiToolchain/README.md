# ruyi toolchain 演示

## 安装 ruyi 包管理器工具

安装需要的工具。

```bash
sudo apt-get update
sudo apt-get install wget git tar bzip2 xz-utils zstd unzip lz4 kate konsole libqt5gui5-gles
```

注意如果没有安装 libqt5gui5-gles 则 kate 将段错误。

在 riscv64 架构环境安装：

```bash
wget https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/0.10.0/ruyi.riscv64
chmod +x ./ruyi.riscv64
sudo cp ./ruyi.riscv64 /usr/bin/ruyi
```

验证 ruyi 安装正常：

```bash
ruyi version
```

安装工具链

```bash
ruyi install gnu-plct-xthead gnu-upstream gnu-plct
```

配置 ``.bashrc``：

```bash
cat << 'EOF' >> ~/.bashrc
[ -e ruyi-lp4a-venv ] && ruyi venv -t gnu-plct-xthead sipeed-lpi4a ruyi-lp4a-venv
. ruyi-lp4a-venv/bin/ruyi-activate

alias gcc=riscv64-plctxthead-linux-gnu-gcc
alias g++=riscv64-plctxthead-linux-gnu-g++
EOF
```