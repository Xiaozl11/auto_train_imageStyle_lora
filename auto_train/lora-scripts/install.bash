#!/usr/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
create_venv=true

while [ -n "$1" ]; do
    case "$1" in
        --disable-venv)
            create_venv=false
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if $create_venv; then
    echo "Creating python venv..."
    python3 -m venv xiao
    source "$script_dir/xiao/bin/activate"
    echo "active venv "
fi

echo "Installing torch & xformers..."
pip install opencv-python-headless # 在虚拟环境中安装才可以
apt-get -y install libxml2
apt-get -y install libgl1
apt-get -y install libglib2.0-dev
cuda_version=$(nvcc --version | grep 'release' | sed -n -e 's/^.*release \([0-9]\+\.[0-9]\+\),.*$/\1/p')
cuda_major_version=$(echo "$cuda_version" | awk -F'.' '{print $1}')
cuda_minor_version=$(echo "$cuda_version" | awk -F'.' '{print $2}')

echo "Cuda Version:$cuda_version"
pip install clearml -i https://pypi.tuna.tsinghua.edu.cn/simple 
if (( cuda_major_version >= 12 )); then
    echo "install torch 2.1.0+cu121"
    pip install torch==2.1.2+cu121 torchvision==0.16.2+cu121 --extra-index-url https://download.pytorch.org/whl/cu121
    pip install --no-deps xformers===0.0.23.post1
elif (( cuda_major_version == 11 && cuda_minor_version >= 8 )); then
    echo "install torch 2.0.1+cu118"
    pip install torch==2.0.1+cu118 torchvision==0.15.2+cu118 --extra-index-url https://download.pytorch.org/whl/cu118
    pip install --no-deps xformers==0.0.21 -i https://pypi.tuna.tsinghua.edu.cn/simple
elif (( cuda_major_version == 11 && cuda_minor_version >= 6 )); then
    echo "install torch 1.12.1+cu116"
    pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116
    # for RTX3090+cu113/cu116 xformers, we need to install this version from source. You can also try xformers==0.0.18
    pip install --upgrade git+https://github.com/facebookresearch/xformers.git@0bad001ddd56c080524d37c84ff58d9cd030ebfd
    pip install triton==2.0.0.dev20221202
elif (( cuda_major_version == 11 && cuda_minor_version >= 2 )); then
    echo "install torch 1.12.1+cu113"
    pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu116
    pip install --upgrade git+https://github.com/facebookresearch/xformers.git@0bad001ddd56c080524d37c84ff58d9cd030ebfd
    pip install triton==2.0.0.dev20221202
else
    echo "Unsupported cuda version:$cuda_version"
    exit 1
fi

echo "Installing deps..."
cd "$script_dir/sd-scripts" || exit

pip install --upgrade -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

cd "$script_dir" || exit

pip install --upgrade -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

echo "Install completed"




