sudo nvidia-docker run -v ~/docker-caffe-rtpose/videos:/home/videos/ -v ~/docker-caffe-rtpose/frames:/home/frames -t -i caffe-rtpose /home/caffe_rtpose/build/examples/rtpose/rtpose.bin --video /home/videos/dancing.mp4 --write_frames /home/frames/ --no_display