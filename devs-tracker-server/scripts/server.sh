#!/bin/bash

sudo apt update
# Install software
sudo apt install -y default-jre net-tools
# Create user
sudo adduser --shell /bin/bash --disabled-password --gecos "" devstracker
# Setup ssh
mkdir /home/devstracker/.ssh
sudo chown devstracker:devstracker /home/devstracker/.ssh
chmod 700 /home/devstracker/.ssh
cp /root/.ssh/authorized_keys /home/devstracker/.ssh/
sudo chown devstracker:devstracker /home/devstracker/.ssh/authorized_keys