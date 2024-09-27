FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# Note: Ubuntu 22 already gets CMake 3.22+ and Python 3.10.2
ENV _CPU_BUILD_CORES=12
ENV CMAKE_VERSION=3.21
ENV CMAKE_BUILD=7
ENV CERES_SOLVER_VERSION=2.0.0
ENV COLMAP_VERSION=3.7
ENV PYTHON_VERSION=3.10.2
#ENV OPENCV_VERSION=4.8.0.76


RUN echo "Installing apt packages..." \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt -y update --no-install-recommends \
	&& apt -y install --no-install-recommends software-properties-common \ 
	&& add-apt-repository -y universe \
	&& apt -y install --no-install-recommends \
	git wget ninja-build build-essential libboost-program-options-dev \
	libboost-filesystem-dev libboost-graph-dev libboost-system-dev libeigen3-dev libflann-dev \
	libfreeimage-dev libmetis-dev libgoogle-glog-dev libgtest-dev libsqlite3-dev libglew-dev \
	qtbase5-dev libqt5opengl5-dev libcgal-dev libssl-dev\
	&& apt -y install --no-install-recommends \
	python3-dev python3-pip libopenexr-dev libxi-dev \
	libglfw3-dev libomp-dev libxinerama-dev libxcursor-dev \
	&& apt -y install --no-install-recommends \
	gcc-10 g++-10 nvidia-cuda-toolkit nvidia-cuda-toolkit-gcc \
	&& apt autoremove -y \
	&& apt clean -y \
	&& export DEBIAN_FRONTEND=dialog


RUN echo "Installing Cmake ver. ${CMAKE_VERSION}.${CMAKE_BUILD}..." \
	&& cd /opt \
	&& wget https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz \
	&& tar -xzvf cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz \
	&& rm cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz \
	&& cd cmake-${CMAKE_VERSION}.${CMAKE_BUILD} \
	&& sh bootstrap \
	&& make -j$_CPU_BUILD_CORES \
	&& make install \
	&& cmake --version 
	

# Only worth building when there is a convenient host-to-docker filesystem pipeline
RUN echo "Building Instant NGP..." \
	&& cd / \
	&& git clone --recursive https://github.com/nvlabs/instant-ngp 
#	&& cd instant-ngp \
#	&& cmake . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo \
#	-DCMAKE_CXX_COMPILER=/usr/bin/g++-10 -DCMAKE_CUDA_COMPILER=/usr/local/cuda-12.3/bin/nvcc \
#	&& cmake --build build --config RelWithDebInfo -j$_CPU_BUILD_CORES 


# Building COLMAP dependency
RUN echo "Installing Ceres Solver ver. ${CERES_SOLVER_VERSION}..." \
	&& cd /opt \
	&& git clone https://github.com/ceres-solver/ceres-solver \
	&& cd ./ceres-solver \
	&& git checkout ${CERES_SOLVER_VERSION} \
	&& mkdir ./build \
	&& cd ./build \
	&& cmake .. -GNinja -DCMAKE_CXX_COMPILER=/usr/bin/g++-10 -DCMAKE_C_COMPILER=/usr/bin/gcc-10 -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF \
	&& ninja -j$_CPU_BUILD_CORES \
	&& ninja install


# Building COLMAP
RUN echo "Installing COLMAP ver. ${COLMAP_VERSION}..." \
	&& cd /opt \
	&& git clone https://github.com/colmap/colmap \
	&& cd ./colmap \
	&& git checkout ${COLMAP_VERSION} \
	&& mkdir ./build \
	&& cd ./build \
	# https://github.com/colmap/colmap/issues/2464#issuecomment-2009050889
	&& echo CUDA_ARCH = $(echo $(nvidia-smi --query-gpu=compute_cap --format=csv) | sed -e 's/[compute_cap ,.]//g') \
	&& cmake .. -GNinja -DCMAKE_CUDA_ARCHITECTURES=$(echo $(nvidia-smi --query-gpu=compute_cap --format=csv) | sed -e 's/[compute_cap ,.]//g') \
	-DCMAKE_CXX_COMPILER=/usr/bin/g++-10 -DCMAKE_C_COMPILER=/usr/bin/gcc-10 -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-11.8 \
	&& ninja -j$_CPU_BUILD_CORES \
	&& ninja install
	

RUN echo "Installing Python ver. ${PYTHON_VERSION}..." \
	&& cd /opt \
	&& wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
	&& tar xzf Python-${PYTHON_VERSION}.tgz \
	&& cd ./Python-${PYTHON_VERSION} \
	&& ./configure --enable-optimizations \
	&& make -j$_CPU_BUILD_CORES


RUN echo "Installing pip packages..." \
	&& python3 -m pip install -U pip \
	&& pip3 --no-cache-dir install commentjson \
	imageio \
	numpy \
	opencv-python-headless \
	pybind11 \
	pyquaternion \
	scipy \
	tqdm 
#	&& pip3 --no-cache-dir install cmake==${CMAKE_VERSION} opencv-python==${OPENCV_VERSION} 

