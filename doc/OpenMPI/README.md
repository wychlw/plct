# OpenMPI on Lichee Cluster

## 系统环境

使用 Lichee Cluster 自带官方镜像（可使用 RuyiSDK 刷写）

## 安装 OpemMPI

确认安装依赖：
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential gcc g++ make cmake
```

在所有系统上均需要进行（不建议在最后拷贝）
```bash
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.3.tar.gz
tar -xzvf openmpi-5.0.3.tar.gz
cd openmpi-5.0.3
./configure --prefix=/
make -j$(nproc)
sudo make install
```

验证安装：
```bash
mpicc --version
mpirun --version
```

## 配置互联

以下步骤所有机器都需要单独运行（文件可直接拷贝）：

查看所有 hosts：
```bash
avahi-browse -all | grep lc4a
```
编写 `all_hosts` 文件（包括主机），格式应该如下：
```bash
lc4axxxx.local
lc4axxxx.local
```
理论上数量和你插的板子块数相同。

生成密钥：
```bash
ssh-keygen
```

拷贝密钥到每台机器上，脚本如下：
```bash
cat << 'EOF' > ssh_copy_id.sh
#!/bin/bash

USER="debian"
KEY_FILE="${HOME}/.ssh/id_rsa.pub"
HOSTS_FILE="all_hosts"
PASSWORD="debian"

if [ ! -f "$KEY_FILE" ]; then
    echo "SSH key file not found. Please generate your SSH key with ssh-keygen."
    exit 1
fi

if [ ! -f "$HOSTS_FILE" ]; then
    echo "Hosts file not found. Please create a file named hosts.txt with the list of hostnames or IP addresses."
    exit 1
fi

while IFS= read -r host; do
    echo "Adding $host to known_hosts"
    ssh-keyscan -H $host >> ~/.ssh/known_hosts

    echo "Copying SSH key to $USER@$host"
    sshpass -p "$PASSWORD" ssh-copy-id -i "$KEY_FILE" "$USER@$host"
done < "$HOSTS_FILE"
EOF
```

运行它：
```bash
chmod +x ssh_copy_id.sh
./ssh_copy_id.sh
```

## 搭建示例程序

### hello_world

程序如下：
```bash
cat << 'EOF' > hello.c
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    // Initialize the MPI environment
    MPI_Init(&argc, &argv);

    // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Get the name of the processor
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    // Print off a hello world message
    printf("Hello world from processor %s, rank %d out of %d processors\n",
           processor_name, world_rank, world_size);

    // Finalize the MPI environment.
    MPI_Finalize();
    return 0;
}
EOF
mpicc -o hello hello.c
```

### hpl

```bash
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make -j$(nproc)
make PREFIX=$HOME/opt/OpenBLAS install
wget https://netlib.org/benchmark/hpl/hpl-2.3.tar.gz
gunzip hpl-2.3.tar.gz
tar xvf hpl-2.3.tar
rm hpl-2.3.tar
mv hpl-2.3 ~/hpl
cd hpl/setup
sh make_generic
cp Make.UNKNOWN ../Make.linux
cd ../
nano Make.linux
```

更换以下内容：
```makefile
arch=linux

MPdir        = /usr/lib64/openmpi/
MPinc        = /usr/include/openmpi-riscv64/
MPlib        = /usr/lib64/openmpi/lib/libmpi.so

LAdir        = $(HOME)/opt/OpenBLAS
LAinc        =
LAlib        = $(LAdir)/lib/libopenblas.a
```

编译：
```bash
make arch=linux
```

## 准备连接

**在每次 IP 变化时均需要**

添加 known_hosts，脚本如下：
```bash
cat << 'EOF' > add_known.sh
#!/bin/bash

USER="debian"
KEY_FILE="${HOME}/.ssh/id_rsa.pub"
HOSTS_FILE="all_hosts"
PASSWORD="debian"

if [ ! -f "$KEY_FILE" ]; then
    echo "SSH key file not found. Please generate your SSH key with ssh-keygen."
    exit 1
fi

if [ ! -f "$HOSTS_FILE" ]; then
    echo "Hosts file not found. Please create a file named hosts.txt with the list of hostnames or IP addresses."
    exit 1
fi

while IFS= read -r host; do
    echo "Adding $host to known_hosts"
    ssh-keyscan -H $host >> ~/.ssh/known_hosts
done < "$HOSTS_FILE"
EOF

chmod +x add_known.sh
```
运行：
```bash
./add_known.sh
```

生成 machine file，脚本如下：
```bash
cat << 'EOF' > gen_machine.sh
#!/bin/bash

DOMAINS_FILE="all_hosts"
MACHINEFILE="machine"

# Clear the machinefile if it already exists
> $MACHINEFILE

# Loop through each domain and perform getent hosts
while IFS= read -r domain; do
    ip=$(getent hosts $domain | awk '{print $1}')
    if [ -n "$ip" ]; then
        echo "debian@$domain slots=4" >> $MACHINEFILE
    else
        echo "Warning: Could not resolve $domain"
    fi
done < "$DOMAINS_FILE"

echo "Machinefile generated: $MACHINEFILE"
EOF
chmod +x gen_machine.sh
```
运行：
```bash
./gen_machine.sh
```

## 运行程序

```bash
mpirun --hostfile machine -np 12 ./hello
```

自行更改线程数（`-np`）和程序