FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV _CPU_BUILD_CORES=12
ENV PATH=/root/miniconda/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CC=/usr/bin/gcc-10
ENV CXX=/usr/bin/g++-10
ENV CUDAHOSTCXX=/usr/bin/g++-10

RUN echo "Installing apt packages..."  \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt -y update --no-install-recommends  \
	&& apt -y install --no-install-recommends software-properties-common \
	&& add-apt-repository -y universe \
	&& add-apt-repository ppa:graphics-drivers/ppa \
	&& apt -y update && apt -y upgrade  && apt -y install --no-install-recommends \
	build-essential \
	git \
	nano \
	wget \
	curl \
	cmake \
	ffmpeg \
	ninja-build \
	nvidia-cuda-toolkit \
	nvidia-cuda-toolkit-gcc \
	g++-10 \
	gcc-10 \
	libboost-program-options-dev \
	libboost-filesystem-dev \
	libboost-graph-dev \
	libboost-system-dev \
	libeigen3-dev \
	libflann-dev \
	libfreeimage-dev \
	libmetis-dev \
	libgoogle-glog-dev \
	libgtest-dev \
	libsqlite3-dev \
	libglew-dev \
	qtbase5-dev \
	libqt5opengl5-dev \
	libcgal-dev \
	libceres-dev \
	&& apt autoremove -y \
	&& apt clean -y \
	&& export DEBIAN_FRONTEND=dialog

RUN echo "Installing miniconda..." \
	&& cd /opt \
	&& wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -b \
	&& ~/miniconda3/bin/conda init

RUN echo "Installing COLMAP..." \
	&& cd /opt \
	&& echo CUDA_ARCH = $(echo $(nvidia-smi --query-gpu=compute_cap --format=csv) | sed -e 's/[compute_cap ,.]//g') \
	&& export _CUDA_ARCH=$(echo $(nvidia-smi --query-gpu=compute_cap --format=csv) | sed -e 's/[compute_cap ,.]//g') \
	&& git clone https://github.com/colmap/colmap.git \
	&& cd ./colmap \
	&& mkdir ./build \
	&& cd ./build \
	&& cmake .. -GNinja -DCMAKE_CUDA_ARCHITECTURES=$_CUDA_ARCH \
	&& ninja -j$_CPU_BUILD_CORES \
	&& ninja install

RUN echo "Building SuGaR dependencies..." \
	&& eval "$(~/miniconda3/bin/conda shell.bash hook)" \
	&& cd / \
	&& git clone https://github.com/Anttwo/SuGaR.git --recursive \
	&& cd ./SuGaR \
	&& conda env create -f environment.yml 

RUN echo "Installing Gaussian Splatting Rasterizer" \ 
	&& eval "$(~/miniconda3/bin/conda shell.bash hook)" \
	&& conda activate sugar \
	&& cd /SuGaR/gaussian_splatting/submodules/ \
	&& python3 -m pip install -e diff-gaussian-rasterization/ \
	&& python3 -m pip install -e simple-knn/
	
