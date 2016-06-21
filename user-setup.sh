#!/bin/bash -xe

sudo yum upgrade -y
sudo yum install -y tmux vim wget git
sudo useradd stack
echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
sudo chmod 0440 /etc/sudoers.d/stack
su - stack
