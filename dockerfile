FROM ubuntu
MAINTAINER Kishore Kadiyala <kishore.kadiyala@intel.com>
LABEL Version="0.0.1"

# Set proxy
#ENV http_proxy 
#ENV https_proxy 

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa

#Create known_hosts
RUN touch /root/.ssh/known_hosts

RUN apt-get update && \ 
    apt-get -y --quiet install \
	automake \
	autoconf \
	libtool \
	xutils-dev \
	libpciaccess-dev \
	python-mako \
	bison \
	flex \
	libomxil-bellagio-dev \
	libexpat1-dev \
	llvm-dev \
#	gcc-4.9 \
#	g++-4.9 \
	python3 \
	python3-pip \
	libudev-dev \
	libmtdev-dev \
	mtdev-tools \
	libevdev-dev \
	libx11-xcb-dev \
	libxkbcommon-dev \
	libxrandr-dev \
	x11proto-*-dev \
	libxcb* \
	libxdamage* \
	libxext-dev \
	libxshmfence-dev \
	libwacom-dev \
	libgtk-3-dev \
	check \
	libpam0g-dev \
	clang-format-4.0 \
#	cppcheck/trusty-backports \
	zlib1g-dev \
	libx11-dev \
	libncurses5-dev \
	libelf-dev \
	libglib2.0-dev \
	git \
	cmake \
	build-essential \
	libircclient-dev \
	libwayland-dev \
	libudev-dev \
	libmtdev-dev \
	libevdev-dev \
	libwacom-dev \
	libinput-dev 

RUN pip3 install meson==0.43.0 \
	ninja \
	pathlib


#Create a workspace
RUN mkdir /root/workspace

#clone latest DRM
RUN git clone https://github.com/projectceladon/external-libdrm.git /root/workspace/libdrm
WORKDIR /root/workspace/libdrm
RUN ./autogen.sh --disable-radeon --disable-nouveau --disable-amdgpu --enable-udev --enable-libkms --prefix=/usr/lib/x86_64-linux-gnu ; make ; make install
RUN make && make install
WORKDIR /

#clone latest MESA
RUN git clone https://github.com/intel/external-mesa.git /root/workspace/mesa
WORKDIR /root/workspace/mesa
RUN ./autogen.sh --prefix=/usr/lib/x86_64-linux-gnu  --with-platforms=surfaceless --disable-dri3 --enable-shared-glapi --disable-glx --disable-glx-tls --without-gallium-drivers --with-dri-drivers=i965 --with-vulkan-drivers=intel
RUN make CFLAGS=-DSYS_memfd_create=319 CPPFLAGS=--std=c11 -j5 && make install
WORKDIR /

#clone latest DEQP

RUN git clone https://android.googlesource.com/platform/external/deqp /root/workspace/deqp
WORKDIR /root/workspace/deqp
RUN mkdir ./build
WORKDIR /root/workspace/deqp/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DDEQP_TARGET=x11_egl -DCMAKE_FLAGS="-m64" -DCMAKE_CXX_FLAGS="-m64"
RUN make
WORKDIR /
