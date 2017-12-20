#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This should be run within the container";
    exit 0;
fi

sudo yum -y update;

rm -rf ~/tripleo-quickstart;
rm -rf ~/.quickstart ;
rm -rf ~/.ansible
rm -rf ~/.ara
rm -rf ~/.novaclient
rm -rf ~/.pki

# We want the root user to have the same keys as us.
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '';
fi
sudo rm -rf /root/.ssh;
sudo cp -r ~/.ssh/ /root/.ssh && sudo chown -R root /root/.ssh;

dt="$(date "+%Y-%m-%d_%H-%M_%s")";

source ~/openrc.sh;

# Manually remove ports and old stacks.
openstack port list --long;
openstack port delete $(openstack port list  -c ID -f value --device-owner=network:dhcp) || true;
openstack port list --long;

openstack stack list;
openstack stack delete -y --wait $(openstack stack list -c ID -f value) || true;
openstack stack list;

git clone https://github.com/openstack/tripleo-quickstart.git ~/tripleo-quickstart;

unbuffer bash ~/tripleo-quickstart/quickstart.sh --install-deps 2>&1 | tee -a logs/$dt.install.log;
