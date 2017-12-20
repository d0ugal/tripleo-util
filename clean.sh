#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This should be run within the container";
    exit 0;
fi

sudo yum -y update;

source ~/openrc.sh;

# Manually remove ports and old stacks.
openstack port list --long;
openstack port delete $(openstack port list  -c ID -f value --device-owner=network:dhcp) || true;
openstack port list --long;

openstack stack list;
openstack stack delete -y --wait $(openstack stack list -c ID -f value) || true;
openstack stack list;
