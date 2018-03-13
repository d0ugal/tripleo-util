#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This should be run within the container";
    exit 0;
fi

sudo yum -y update;

source ~/openrc.sh;

# Manually remove old things.
openstack port delete $(openstack port list  -c ID -f value --device-owner=network:dhcp) || true;
openstack stack delete -y --wait $(openstack stack list -c ID -f value) || true;
openstack keypair delete $(openstack keypair list -c Name -f value) || true;

# List them in the output, just so I can verify
openstack port list --long;
openstack stack list;

# We want the root user to have the same keys as us. I forget why.
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '';
fi
sudo rm -rf /root/.ssh;
sudo cp -r ~/.ssh/ /root/.ssh && sudo chown -R root /root/.ssh;
