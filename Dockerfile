FROM nvidia/cuda:8.0-cudnn5-runtime-ubuntu16.04

LABEL maintainer "Alex McLeod <alex@mcleod.io>"

# http://www.pyimagesearch.com/2015/06/22/install-opencv-3-0-and-python-2-7-on-ubuntu/#comment-416102

RUN apt-get update -y
RUN apt-get upgrade -y

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

# The extra bits fix an issue with 3.1.0 and CUDA 8.0 compatibility. See https://github.com/opencv/opencv/issues/6677.
RUN git checkout 3.1.0 && git format-patch -1 10896129b39655e19e4e7c529153cb5c2191a1db && git am < 0001-GraphCut-deprecated-in-CUDA-7.5-and-removed-in-8.0.patch

WORKDIR /home

RUN git clone https://github.com/Itseez/opencv_contrib.git

WORKDIR /home/opencv_contrib

RUN git checkout 3.1.0

WORKDIR  /home/opencv

RUN mkdir build

WORKDIR /home/opencv/ build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

RUN make -j8

RUN make install

RUN ldconfig
