install-deps: 
	./install-docker.sh && ./install-nvidia-docker.sh

build: 
	sudo nvidia-docker build -t caffe-rtpose .

run: 
	sudo nvidia-docker run caffe-rtpose

