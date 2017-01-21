# https://docs.docker.com/engine/installation/linux/ubuntu/

set -e

sudo apt-get update -y

sudo apt-get install curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual -y

sudo apt-get install apt-transport-https \
                       ca-certificates -y

curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main" -y

sudo apt-get update -y

sudo apt-get -y install docker-engine


