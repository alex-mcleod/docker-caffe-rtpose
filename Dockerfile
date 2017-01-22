FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

LABEL maintainer "Alex McLeod <alex@mcleod.io>"

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade -y

# Install OpenCV based on http://www.pyimagesearch.com/2015/06/22/install-opencv-3-0-and-python-2-7-on-ubuntu/#comment-416102

RUN apt-get install build-essential cmake git pkg-config -y

RUN apt-get install libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev -y

RUN apt-get install libgtk2.0-dev -y

RUN apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev -y

RUN apt-get install libatlas-base-dev gfortran -y

RUN apt-get install wget -y

RUN wget https://bootstrap.pypa.io/get-pip.py

RUN python get-pip.py

RUN rm get-pip.py

RUN apt-get install python2.7-dev python-dev -y

RUN pip install numpy

WORKDIR /home

RUN git config --global user.email "alex@mcleod.io"

RUN git config --global user.name "Alex McLeod"

RUN git clone https://github.com/Itseez/opencv.git

WORKDIR /home/opencv

# The extra bits fix an issue with OpenCV and CUDA 8.0 compatibility. See https://github.com/opencv/opencv/issues/6677.
RUN git checkout 3.1.0 && git format-patch -1 10896129b39655e19e4e7c529153cb5c2191a1db && git am < 0001-GraphCut-deprecated-in-CUDA-7.5-and-removed-in-8.0.patch

WORKDIR /home

RUN git clone https://github.com/Itseez/opencv_contrib.git

WORKDIR /home/opencv_contrib

RUN git checkout 3.1.0

WORKDIR  /home/opencv

RUN mkdir build

WORKDIR /home/opencv/ build

# Run this or else cmake will fail
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/libcuda.so
RUN ldconfig

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/home/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

RUN make -j8

RUN make install

RUN ldconfig

# Install Caffe and the rtpose program. Based on https://github.com/alex-mcleod/caffe_rtpose.

WORKDIR /home

RUN git clone https://github.com/alex-mcleod/caffe_rtpose

WORKDIR /home/caffe_rtpose

# Checkout correct commit (update this as necessary)
RUN git pull && git reset --hard  5c38183ccc6a8937cb018842ce0259a02e89a594

RUN chmod u+x install_caffe_and_cpm.sh

RUN apt-get install -y libhdf5-dev lsb-release libgflags-dev libgoogle-glog-dev liblmdb-dev

RUN ./install_caffe_and_cpm.sh

# Add a "fake" display
# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN apt-get install -y x11vnc xvfb
RUN mkdir ~/.vnc
# Setup a password
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd
