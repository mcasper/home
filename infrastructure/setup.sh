#!/bin/bash

set -eou pipefail

sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) test"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install -y docker-ce docker-compose

echo "Installed docker"
