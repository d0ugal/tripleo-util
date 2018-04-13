#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This should be run within the container";
    exit 0;
fi

sudo yum -y update;

# We want the root user to have the same keys as us. I forget why.
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '';
fi
sudo rm -rf /root/.ssh;
sudo cp -r ~/.ssh/ /root/.ssh && sudo chown -R root /root/.ssh;
