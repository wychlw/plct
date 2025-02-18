#!/bin/bash

#set -x

with_v=false
without_v=false
thread=32
model="DeepSeek-R1-Distill-Qwen-1.5B-Q4_K_M.gguf"
build=false

function install_deps() {
	sudo apt-get -y install wget git
}

function get_toolchains() {
	if [ ! -f "RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu.tar.xz" ]; then
		wget "https://mirror.iscas.ac.cn/ruyisdk/dist/RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu.tar.xz"
	fi
	if [ ! -f "RuyiSDK-20231212-Upstream-Sources-HOST-riscv64-linux-gnu-riscv64-unknown-linux-gnu.tar.xz" ]; then
		wget "https://mirror.iscas.ac.cn/ruyisdk/dist/RuyiSDK-20231212-Upstream-Sources-HOST-riscv64-linux-gnu-riscv64-unknown-linux-gnu.tar.xz"
	fi

	if [ ! -d "plctxthead_toolchain" ]; then
		tar -xvf "RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu.tar.xz"
		mv "RuyiSDK-20240222-T-Head-Sources-T-Head-2.8.0-HOST-riscv64-linux-gnu-riscv64-plctxthead-linux-gnu" plctxthead_toolchain
	fi
	if [ ! -d "upstream_toolchain" ]; then
		tar -xvf "RuyiSDK-20231212-Upstream-Sources-HOST-riscv64-linux-gnu-riscv64-unknown-linux-gnu.tar.xz"
		mv "RuyiSDK-20231212-Upstream-Sources-HOST-riscv64-linux-gnu-riscv64-unknown-linux-gnu" upstream_toolchain
	fi
}

function clone_repo() {
	base_dir="$1"
	pushd "$base_dir"
	if [ ! -d "OpenBLAS" ]; then
		git clone https://github.com/OpenMathLib/OpenBLAS
	fi
	if [ ! -d "llama.cpp" ]; then
		git clone https://github.com/ggerganov/llama.cpp.git
	fi
	popd
}

function patch_rvv() {
	base_dir="$1"
	pushd "$base_dir"
	cat << EOF > llama.cpp.patch
diff --git a/ggml/src/ggml-cpu/CMakeLists.txt b/ggml/src/ggml-cpu/CMakeLists.txt
index 98fd18e..0e6f302 100644
--- a/ggml/src/ggml-cpu/CMakeLists.txt
+++ b/ggml/src/ggml-cpu/CMakeLists.txt
@@ -306,7 +306,7 @@ function(ggml_add_cpu_backend_variant_impl tag_name)
     elseif (${CMAKE_SYSTEM_PROCESSOR} MATCHES "riscv64")
         message(STATUS "RISC-V detected")
         if (GGML_RVV)
-            list(APPEND ARCH_FLAGS -march=rv64gcv -mabi=lp64d)
+            list(APPEND ARCH_FLAGS -march=rv64gcv0p7 -mabi=lp64d)
         endif()
     else()
         message(STATUS "Unknown architecture")
EOF
	pushd "llama.cpp"
	patch -p1 -f < ../llama.cpp.patch
	popd
	popd
}

function patch_no_rvv() {
	base_dir="$1"
	pushd "$base_dir"
	cat << EOF > llama.cpp.patch
diff --git a/ggml/src/ggml-cpu/CMakeLists.txt b/ggml/src/ggml-cpu/CMakeLists.txt
index 98fd18e..0e6f302 100644
--- a/ggml/src/ggml-cpu/CMakeLists.txt
+++ b/ggml/src/ggml-cpu/CMakeLists.txt
@@ -306,7 +306,7 @@ function(ggml_add_cpu_backend_variant_impl tag_name)
     elseif (${CMAKE_SYSTEM_PROCESSOR} MATCHES "riscv64")
         message(STATUS "RISC-V detected")
         if (GGML_RVV)
-            list(APPEND ARCH_FLAGS -march=rv64gcv -mabi=lp64d)
+            list(APPEND ARCH_FLAGS -march=rv64gc -mabi=lp64d)
         endif()
     else()
         message(STATUS "Unknown architecture")
EOF
	pushd "llama.cpp"
	patch -p1 -f < ../llama.cpp.patch
	popd
	popd
}

function compile() {
	base_dir="$1"
	c_c="$2"
	f_c="$3"
	target="$4"
	sysroot="$5"

	pushd "$base_dir"
	
	pushd "OpenBLAS"
	make HOSTCC=$c_c TARGET=$target CC=$c_c FC=$f_c -j32
	make install PREFIX="$sysroot/usr"
	sudo make install PREFIX="/usr/local"
	popd

	pushd "llama.cpp"
	CC=$c_c FC=$f_c cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
	cmake --build build --config Release -j32


	libopenblas_path="$sysroot/usr/lib"
	pushd "build/bin"
	find $libopenblas_path -name "libopenblas*" | xargs -I {} cp {} .
	popd

	popd

	popd

	find /usr/local/lib -name "libopenblas*" | xargs sudo rm
}

function run_bench() {
	base_dir="$1"

	pushd "$base_dir"

	pushd "llama.cpp/build/bin"
	echo "Running in $(pwd)"
	echo "./llama-bench -m "$model" -t $thread"
	./llama-bench -m "$model" -t $thread

	popd

	popd
}

clean=false

function print_help() {
	text="run.sh: Run bench in llama.cpp with backend OpenBLAS
	-rvv [dir] 	run the bench with rvv in [dir]
	-no_rvv [dir] 	run the bench without rvv in [dir]
	-a | --all	run both bench, dir defaults to with_v and without_v
	-t | --thread [thread count]	run model with thread count
	-m | --model [path]	run bench using model [path], default to DeepSeek-R1-Distill-Qwen-1.5B-Q4_K_M.gguf
	-c | --clean	delete all generated files
	-b | --build	run build
	-h | --help	print this message
	"
	echo "$text"
}

function parse_args() {
	while [[ $# -gt 0 ]]; do
		case $1 in
			-rvv)
				with_v="$2"
				shift
				shift
				;;
			-no_rvv)
				without_v="$2"
				shift
				shift
				;;
			-a|--all)
				with_v="with_v"
				without_v="without_v"
				shift
				;;
			-t|--thread)
				thread="$2"
				shift
				shift
				;;
			-m|--model)
				model="$2"
				shift
				shift
				;;
			-b|--build)
				build=true
				shift
				;;
			-c|--clean)
				clean=true
				shift
				;;
			-h|--help)
				print_help
				exit 0
				;;
			*)
				print_help
				exit 0
				;;
		esac
	done
}

function clean() {
	if [ ! "$with_v" = false ]; then
		rm -rf "$with_c"
	fi
	if [ ! "$without_v" = false ]; then
		rm -rf "$without_v"
	fi
	exit 0
}

function main() {

	if [ "$clean" = true ]; then
		clean
	fi

	if [ "$build" = true ]; then
		install_deps
		get_toolchains
	
	if [ ! "$with_v" = false ]; then
		base_dir="$with_v"
		mkdir -p "$base_dir"
		clone_repo "$base_dir"
		patch_rvv "$base_dir"

		ori_path=$PATH
		toolchain_path=$(realpath plctxthead_toolchain/bin/)
		sysroot_path=$(realpath plctxthead_toolchain/riscv64-plctxthead-linux-gnu/sysroot/) 
		export PATH=$toolchain_path:$ori_path
		compile "$base_dir" "riscv64-plctxthead-linux-gnu-gcc" "riscv64-plctxthead-linux-gnu-gfortran" "C910V" "$sysroot_path"

		export PATH=$ori_path
	fi

	if [ ! "$without_v" = false ] ; then
		base_dir="$without_v"
		mkdir -p "$base_dir"
		clone_repo "$base_dir"
		patch_no_rvv "$base_dir"

		ori_path=$PATH
		toolchain_path=$(realpath upstream_toolchain/bin/)
		sysroot_path=$(realpath upstream_toolchain/riscv64-unknown-linux-gnu/sysroot/) 
		export PATH=$toolchain_path:$ori_path
		compile "$base_dir" "riscv64-unknown-linux-gnu-gcc" "riscv64-unknown-linux-gnu-gfortran" "RISCV64_GENERIC" "$sysroot_path"

		export PATH="$ort_path"
	fi
	fi

	if [ ! "$with_v" = false ]; then
		echo "With RVV:"
		run_bench "$with_v"
	fi
	if [ ! "$without_v" = false ]; then
		echo "No RVV:"
		run_bench "$without_v"
	fi
}
parse_args "$@"
model=$(realpath "$model")
main
