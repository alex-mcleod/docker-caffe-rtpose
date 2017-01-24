# docker-caffe-rtpose
Docker image for building and running caffe-rtpose (https://github.com/CMU-Perceptual-Computing-Lab/caffe_rtpose).

## Quick start

1. Install Docker, Nvidia Docker (https://github.com/NVIDIA/nvidia-docker) and a Nvidia driver by running `make install-deps`. This has been tested on an AWS g2.2xlarge instance running Ubuntu 16.04. You will need to restart the machine after running.

2. Run `make build` to build caffe_rtpose and all of it's dependencies. This will use a forked version of caffe_rtpose which has a properly configured Makefile.config for this environment.

3. Run the caffe_rtpose program. For example: 

`sudo nvidia-docker run -v ~/docker-caffe-rtpose/videos:/home/videos/ -v ~/docker-caffe-rtpose/frames:/home/frames -t -i caffe-rtpose /home/caffe_rtpose/build/examples/rtpose/rtpose.bin --video /home/videos/dancing.mp4 --write_frames /home/frames/ --no_display`

Would run the program and connect up a `videos` volume (which is used for input videos) and a `frames` volume (which is used for output). Then it would run the program on a video called `dancing.mp4`. See the original caffe_rtpose repo for a description of the other options available.

## Still to come

Currently the `--no_display` flag must be used or the program will not run. I have tried using X11 forwarding to allow the Docker container running on a remote machine to output to the local display, but with no luck. If this Docker image is run locally, then it may work. This Stackoverflow answer gives an overview of how it can be done: http://stackoverflow.com/a/25168483.
