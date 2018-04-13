#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This should be run within the container";
    exit 0;
fi

source ~/openrc.sh;

# Delete all the things. Who needs things anyway
openstack port delete $(openstack port list  -c ID -f value --device-owner=network:dhcp) || true;
openstack security group delete $(openstack security group list -c Name -f value) || true;
openstack stack delete -y --wait $(openstack stack list -c ID -f value) || true;
openstack server delete $(openstack server list -c Name -f value) || true;
openstack keypair delete $(openstack keypair list -c Name -f value) || true;
openstack network delete $(openstack network list -c Name -f value) || true;
