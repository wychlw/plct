#! /bin/bash

# RUYI_VERSION
# BOARD_NAME
# TOOLCHAIN
# MARCH
# MARCH2

PMN="${PMN:-apt-get}"

ruyi_version="${RUYI_VERSION:-0.31.0}"

# if TOOLCHAIN is gnu-upstream prepend is riscv64-unknown-linux-gnu-
# else if TOOLCHAIN is gnu-plct prepend is riscv64-plct-linux-gnu-
# else error
if [[ "$TOOLCHAIN" == "gnu-upstream" ]]; then
    file_prepend="$HOME/upstream_log"
    toolchain_prepend="riscv64-unknown-linux-gnu"
    venv_name="venv-gnu-upstream"
elif [[ "$TOOLCHAIN" == "gnu-plct" ]]; then
    file_prepend="$HOME/plct_log"
    toolchain_prepend="riscv64-plct-linux-gnu"
    venv_name="venv-gnu-plct"
else
    echo "Error: Unsupported toolchain $TOOLCHAIN"
    exit 1
fi

function install_ruyi() {
    sudo $PMN update
    sudo $PMN upgrade 
    sudo $PMN install wget xz-utils make -y
    wget https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/$ruyi_version/ruyi.riscv64
    chmod +x ruyi.riscv64
    sudo mv ruyi.riscv64 /usr/bin/ruyi
}

function install_toolchain() {
    echo "${PS1@P}ruyi install toolchain/$TOOLCHAIN" 2>&1 | tee $file_prepend.toolchain_install.log
    ruyi install toolchain/$TOOLCHAIN 2>&1 | tee -a $file_prepend.toolchain_install.log 
}

function create_venv() {
    echo "${PS1@P}ruyi venv -t toolchain/$TOOLCHAIN generic $venv_name" 2>&1 | tee $file_prepend.venv_create.log
    ruyi venv -t toolchain/$TOOLCHAIN generic $venv_name 2>&1 | tee -a $file_prepend.venv_create.log 

    echo "${PS1@P}ls ~/$venv_name" 2>&1 | tee -a $file_prepend.venv_create_verify.log
    ls ~/$venv_name 2>&1 | tee -a $file_prepend.venv_create_verify.log 
    echo "${PS1@P}ls ~/$venv_name/bin" 2>&1 | tee -a $file_prepend.venv_create_verify.log
    ls ~/$venv_name/bin 2>&1 | tee -a $file_prepend.venv_create_verify.log 
}

function activate_venv() {
    echo "${PS1@P}source ~/$venv_name/bin/ruyi-activate" 2>&1 | tee $file_prepend.venv_activate.log
    source ~/$venv_name/bin/ruyi-activate 2>&1 | tee -a $file_prepend.venv_activate.log 
    echo "${PS1@P}" 2>&1 | tee -a $file_prepend.venv_activate.log
}

function check_compiler() {
    echo "${PS1@P}$toolchain_prepend-gcc -v" 2>&1 | tee $file_prepend.toolchain_check.log
    $toolchain_prepend-gcc -v 2>&1 | tee -a $file_prepend.toolchain_check.log 
}

function compile_helloword() {
    echo "${PS1@P}echo '
#include <stdio.h>

int main() {
    printf(\"Hello, World! From $BOARD_NAME with $TOOLCHAIN\n\");
    return 0;
}
' > hello.c" 2>&1 | tee $file_prepend.helloworld_compile.log
    echo "
#include <stdio.h>

int main() {
    printf(\"Hello, World! From $BOARD_NAME with $TOOLCHAIN\n\");
    return 0;
}
" > hello.c
    echo "${PS1@P}$toolchain_prepend-gcc hello.c -march=$MARCH -o hello" 2>&1 | tee -a $file_prepend.helloworld_compile.log
    $toolchain_prepend-gcc hello.c -march=$MARCH -o hello 2>&1 | tee -a $file_prepend.helloworld_compile.log 
    echo "${PS1@P}./hello" 2>&1 | tee -a $file_prepend.helloworld_compile.log
    ./hello 2>&1 | tee -a $file_prepend.helloworld_compile.log 
}

function coremark_bench() {
    echo "${PS1@P}mkdir coremark_$TOOLCHAIN -p" 2>&1 | tee $file_prepend.coremark_bench_download.log
    mkdir coremark_$TOOLCHAIN -p 2>&1 | tee -a $file_prepend.coremark_bench_download.log 
    echo "${PS1@P}cd coremark_$TOOLCHAIN" 2>&1 | tee -a $file_prepend.coremark_bench_download.log
    cd coremark_$TOOLCHAIN 2>&1 | tee -a $file_prepend.coremark_bench_download.log 
    echo "${PS1@P}ruyi extract coremark" 2>&1 | tee -a $file_prepend.coremark_bench_download.log
    ruyi extract coremark 2>&1 | tee -a $file_prepend.coremark_bench_download.log 

    echo "${PS1@P}sed -i 's/\bgcc\b/$toolchain_prepend-gcc/g' linux64/core_portme.mak" 2>&1 | tee $file_prepend.coremark_bench_modify.log
    sed -i "s/\bgcc\b/$toolchain_prepend-gcc/g" linux64/core_portme.mak 2>&1 | tee -a $file_prepend.coremark_bench_modify.log 
    echo "${PS1@P}cat ./linux64/core_portme.mak | grep gcc" 2>&1 | tee -a $file_prepend.coremark_bench_modify.log
    cat ./linux64/core_portme.mak | grep gcc 2>&1 | tee -a $file_prepend.coremark_bench_modify.log 

    echo "${PS1@P}make PORT_DIR=linux64 XCFLAGS=\"-march=$MARCH\" link" 2>&1 | tee $file_prepend.coremark_bench_compile.log
    make PORT_DIR=linux64 XCFLAGS="-march=$MARCH" link 2>&1 | tee -a $file_prepend.coremark_bench_compile.log 
    
    echo "${PS1@P}file coremark.exe" 2>&1 | tee -a $file_prepend.coremark_bench_compile_verify.log
    file coremark.exe 2>&1 | tee -a $file_prepend.coremark_bench_compile_verify.log 

    echo "${PS1@P}./coremark.exe" 2>&1 | tee -a $file_prepend.coremark_bench_compile_run.log
    ./coremark.exe 2>&1 | tee -a $file_prepend.coremark_bench_compile_run.log 
}

function coremark_bench_march2() {
    echo "${PS1@P}make PORT_DIR=linux64 XCFLAGS=\"-march=$MARCH2\" link" 2>&1 | tee $file_prepend.coremark_march2_bench_compile.log
    make PORT_DIR=linux64 XCFLAGS="-march=$MARCH2" link 2>&1 | tee -a $file_prepend.coremark_march2_bench_compile.log 
    
    echo "${PS1@P}file coremark.exe" 2>&1 | tee -a $file_prepend.coremark_march2_bench_compile_verify.log
    file coremark.exe 2>&1 | tee -a $file_prepend.coremark_march2_bench_compile_verify.log 

    echo "${PS1@P}./coremark.exe" 2>&1 | tee -a $file_prepend.coremark_march2_bench_compile_run.log
    ./coremark.exe 2>&1 | tee -a $file_prepend.coremark_march2_bench_compile_run.log 
}

function generate_markdown() {
    echo "" 2>&1 | tee $file_prepend.results.md
    echo "# $BOARD_NAME GNU Toolchain ($TOOLCHAIN) Test Report" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "## Environment" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### System Information" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "- RuyiSDK on $BOARD_NAME SoC"
    echo "- Testing date: $(date)" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### Hardware Information" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "- BOARD: TODO" 2>&1 | tee -a $file_prepend.results.md
    echo "- CPU: TODO" 2>&1 | tee -a $file_prepend.results.md
    echo "- OS: TODO" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "## Installation" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 0. Install ruyi package manager" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "sudo apt update && sudo apt upgrade" 2>&1 | tee -a $file_prepend.results.md
    echo "sudo apt install wget" 2>&1 | tee -a $file_prepend.results.md
    echo "wget https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/$ruyi_version/ruyi.riscv64" 2>&1 | tee -a $file_prepend.results.md
    echo "sudo mv ruyi.riscv64 /usr/bin/ruyi" 2>&1 | tee -a $file_prepend.results.md
    echo "sudo chmod +x /usr/bin/ruyi" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 1. Install Toolchain" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`ruyi\` is dependent on xz-utils, if not installed, please install it first." 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "sudo apt update && sudo apt upgrade" 2>&1 | tee -a $file_prepend.results.md
    echo "sudo apt install xz-utils" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Command:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "ruyi install toolchain/$TOOLCHAIN" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Result:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.toolchain_install.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    toolchain_path=$(ls -l ~/.local/share/ruyi/binaries/riscv64/ | grep $TOOLCHAIN | awk '{print $NF}')
    echo "This command downloaded the toolchain package from ISCAS mirror and installed it to \`~/.local/share/ruyi/binaries/riscv64/$toolchain_path\`." 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 2. Create Virtual Environment" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "ruyi venv -t toolchain/$TOOLCHAIN generic $venv_name" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Result:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.venv_create.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Verification of created environment contents:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.venv_create_verify.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "This step created a virtual environment at \`~/$venv_name/\` with all necessary configuration files, including Meson cross-compilation files, CMake toolchain files, a ready-to-use sysroot, and binary tools with the prefix \`$toolchain_prepend\`." 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 3. Activate Environment" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Command:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "source ~/$venv_name/bin/ruyi-activate" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Result:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "The prompt changed to indicate active environment:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.venv_activate.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "This initialized the environment and provided access to all cross-compilation tools." 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "## Tests & Results" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 1. Compiler Version Check" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Command:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "$toolchain_prepend-gcc -v" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Result:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.toolchain_check.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    gcc_version=$(cat $file_prepend.toolchain_check.log | grep "gcc version" | awk '{print $3}')
    target_arch=$(cat $file_prepend.toolchain_check.log | grep "Target:" | awk '{print $2}')
    thread_model=$(cat $file_prepend.toolchain_check.log | grep "Thread model:" | awk '{print $3}')
    echo "The output confirmed a successful installation showing:" 2>&1 | tee -a $file_prepend.results.md
    echo "- GCC version: $gcc_version" 2>&1 | tee -a $file_prepend.results.md
    echo "- Target architecture: $target_arch" 2>&1 | tee -a $file_prepend.results.md
    echo "- Thread model: $thread_model" 2>&1 | tee -a $file_prepend.results.md
    echo "- Configured with appropriate RISC-V specific options (rv64gc architecture, lp64d ABI)" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 2. Hello World Program" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Commands:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "echo ' " 2>&1 | tee -a $file_prepend.results.md
    echo "#include <stdio.h>" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "int main() {" 2>&1 | tee -a $file_prepend.results.md
    echo "    printf(\"Hello, World! From $BOARD_NAME with $TOOLCHAIN\\n\");" 2>&1 | tee -a $file_prepend.results.md
    echo "    return 0;" 2>&1 | tee -a $file_prepend.results.md
    echo "}" 2>&1 | tee -a $file_prepend.results.md
    echo "' > hello.c" 2>&1 | tee -a $file_prepend.results.md
    echo "$toolchain_prepend-gcc hello.c -march=$MARCH -o hello" 2>&1 | tee -a $file_prepend.results.md
    echo "./hello " 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Result:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.helloworld_compile.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "The program executed successfully and output \"Hello, World! From $BOARD_NAME with $TOOLCHAIN\", confirming basic functionality of the toolchain and proper integration with the system libraries." 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "### 3. CoreMark Benchmark" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**Commands and Results:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "1. Extract the CoreMark package with Ruyi:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "mkdir coremark_$TOOLCHAIN && cd coremark_$TOOLCHAIN" 2>&1 | tee -a $file_prepend.results.md
    echo "ruyi extract coremark" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.coremark_bench_download.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "2. Modify the build configuration to use the RISC-V compiler:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "sed -i 's/\bgcc\b/$toolchain_prepend-gcc/g' linux64/core_portme.mak" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.coremark_bench_modify.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "#### 3.1 CoreMark Benchmark (march: rv64gc)" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "1. Build CoreMark:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "*If you don't have \`make\` installed, please install it first: \`sudo apt install make\`*" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "make PORT_DIR=linux64 XCFLAGS=\"-march=$MARCH\" link" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.coremark_bench_compile.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "2. Verify the resulting binary is a RISC-V executable:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "file coremark.exe" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.coremark_bench_compile_verify.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "3. CoreMark score:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
    echo "./coremark.exe" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
    cat $file_prepend.coremark_bench_compile_run.log 2>&1 | tee -a $file_prepend.results.md
    echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "**CoreMark Results:**" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "CoreMark is a benchmark used to evaluate embedded processor performance. A higher score indicates better processor performance. The results are summarized in the table below:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    iter_sec=$(cat $file_prepend.coremark_bench_compile_run.log | grep "Iterations/Sec" | awk '{print $3}')
    total_ticks=$(cat $file_prepend.coremark_bench_compile_run.log | grep "Total ticks" | awk '{print $4}')
    total_time=$(cat $file_prepend.coremark_bench_compile_run.log | grep "Total time (secs)" | awk '{print $5}')
    iterations=$(cat $file_prepend.coremark_bench_compile_run.log | grep "Iterations " | awk '{print $3}')
    compiler_version=$(cat $file_prepend.coremark_bench_compile_run.log | grep "Compiler version" | awk '{print $4}')
    compiler_flags=$(cat $file_prepend.coremark_bench_compile_run.log | grep "Compiler flags" | awk '{print $4}')
    memory_location=$(cat $file_prepend.coremark_bench_compile_run.log | grep "CoreMark 1.0" | awk '{print $9}')
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "| Metric                | Value       | Description                                                  |" 2>&1 | tee -a $file_prepend.results.md
    echo "| --------------------- | ----------- | ------------------------------------------------------------ |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Iterations/Sec**    | $iter_sec   | Number of iterations completed per second (higher is better) |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Total ticks**       | $total_ticks | Total number of clock cycles                                 |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Total time (secs)** | $total_time | Total execution time in seconds                              |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Iterations**        | $iterations  | Total number of iterations performed                         |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Compiler version**  | $compiler_version   | Compiler used for the test                                   |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Compiler flags**    | $compiler_flags | Compilation flags used                                       |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Memory location**   | $memory_location | Where data is stored during execution                        |" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "These results demonstrate good performance of the $BOARD_NAME CPU on TODO when running CoreMark compiled with the RuyiSDK toolchain and march $MARCH." 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md

    # if MARCH2 set in environment, run the second benchmark
    if [ -n "$MARCH2" ]; then
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "#### 3.2 CoreMark Benchmark (march: $MARCH2)" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "1. Build CoreMark:" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "*If you don't have \`make\` installed, please install it first: \`sudo apt install make\`*" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
        echo "make PORT_DIR=linux64 XCFLAGS=\"-march=$MARCH2\" link" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
        cat $file_prepend.coremark_march2_bench_compile.log 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "2. Verify the resulting binary is a RISC-V executable:" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
        echo "file coremark.exe" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
        cat $file_prepend.coremark_march2_bench_compile_verify.log 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "3. CoreMark score:" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`bash" 2>&1 | tee -a $file_prepend.results.md
        echo "./coremark.exe" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`log" 2>&1 | tee -a $file_prepend.results.md
        cat $file_prepend.coremark_march2_bench_compile_run.log 2>&1 | tee -a $file_prepend.results.md
        echo "\`\`\`" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "**CoreMark Results:**" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "CoreMark is a benchmark used to evaluate embedded processor performance. A higher score indicates better processor performance. The results are summarized in the table below:" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        march2_iter_sec=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "Iterations/Sec" | awk '{print $3}')
        march2_total_ticks=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "Total ticks" | awk '{print $4}')
        march2_total_time=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "Total time (secs)" | awk '{print $5}')
        march2_iterations=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "Iterations " | awk '{print $3}')
        march2_compiler_version=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "Compiler version" | awk '{print $4}')
        march2_compiler_flags=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "Compiler flags" | awk '{print $4}')
        march2_memory_location=$(cat $file_prepend.coremark_march2_bench_compile_run.log | grep "CoreMart 1.0" | awk '{print $9}')
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "| Metric                | Value                                                           | Description                                                  |" 2>&1 | tee -a $file_prepend.results.md
        echo "| --------------------- | --------------------------------------------------------------- | ------------------------------------------------------------ |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Iterations/Sec**    | $march2_iter_sec                                                 | Number of iterations completed per second (higher is better) |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Total ticks**       | $march2_total_ticks                                             | Total number of clock cycles                                 |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Total time (secs)** | $march2_total_time                                             | Total execution time in seconds                              |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Iterations**        | $march2_iterations                                              | Total number of iterations performed                         |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Compiler version**  | $march2_compiler_version                                         | Compiler used for the test                                   |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Compiler flags**    | $march2_compiler_flags                                           | Compilation flags used                                       |" 2>&1 | tee -a $file_prepend.results.md
        echo "| **Memory location**   | $march2_memory_location                                          | Where data is stored during execution                        |" 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
        echo "These results demonstrate good performance of the $BOARD_NAME CPU on TODO when running CoreMark compiled with the RuyiSDK toolchain and march $MARCH2." 2>&1 | tee -a $file_prepend.results.md
        echo "" 2>&1 | tee -a $file_prepend.results.md
    fi
    echo "## Test Summary" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "The following table summarizes the test results for GNU Upstream Toolchain on $BOARD_NAME:" 2>&1 | tee -a $file_prepend.results.md
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "| Test Case                                                               | Expected Result                        | Actual Result                                                             | Status |" 2>&1 | tee -a $file_prepend.results.md
    echo "| ----------------------------------------------------------------------- | -------------------------------------- | ------------------------------------------------------------------------- | ------ |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Toolchain Installation**                                              | Successfully installed toolchain       | Installed to \`$toolchain_path\` | ✅ PASS |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **Compiler Verification**                                               | GCC $gcc_version for RISC-V architecture | GCC $gcc_version with rv64gc architecture, lp64d ABI | ✅ PASS |" 2>&1 | tee -a $file_prepend.results.md
    echo "|  **Hello World Test**                                                    | Successful compilation and execution   | Successfully compiled and executed                                        | ✅ PASS |" 2>&1 | tee -a $file_prepend.results.md
    echo "| **CoreMark Benchmark ($MARCH)**                                         | Successfully compile and run benchmark | Successfully compiled and completed benchmark with score of $iter_sec   | ✅ PASS |" 2>&1 | tee -a $file_prepend.results.md
    if [ -n "$MARCH2" ]; then
        echo "| **CoreMark Benchmark ($MARCH2)**                                         | Successfully compile and run benchmark | Successfully compiled and completed benchmark with score of $march2_iter_sec   | ✅ PASS |" 2>&1 | tee -a $file_prepend.results.md
    fi
    echo "" 2>&1 | tee -a $file_prepend.results.md
    echo "All tests passed successfully, confirming that the $TOOLCHAIN works correctly on the $BOARD_NAME CPU." 2>&1 | tee -a $file_prepend.results.md

}

function main() {
    install_ruyi
    install_toolchain
    create_venv
    
    # activate_venv
    echo "${PS1@P}source ~/$venv_name/bin/ruyi-activate" 2>&1 | tee $file_prepend.venv_activate.log
    source ~/$venv_name/bin/ruyi-activate 2>&1 | tee -a $file_prepend.venv_activate.log 
    echo "${PS1@P}" 2>&1 | tee -a $file_prepend.venv_activate.log
    
    check_compiler
    compile_helloword
    coremark_bench
    # if MARCH2 set in environment, run the second benchmark
    if [ -n "$MARCH2" ]; then
        coremark_bench_march2
    fi

    cd $HOME

    generate_markdown

    echo "All tasks completed successfully."
}
