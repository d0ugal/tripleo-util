#!/bin/bash
set -eux
set -o pipefail

TRIPLEO_ROOT=~/tripleo-heat-templates/;

~/venv/bin/openstack overcloud deploy \
    --templates=$TRIPLEO_ROOT \
    -e $TRIPLEO_ROOT/environments/network-isolation.yaml \
    -e $TRIPLEO_ROOT/environments/net-single-nic-with-vlans.yaml \
    -e $TRIPLEO_ROOT/environments/puppet-pacemaker.yaml \
    -e $TRIPLEO_ROOT/environments/puppet-ceph-devel.yaml \
    -e $TRIPLEO_ROOT/environments/mongodb-nojournal.yaml \ \
    -e custom.yaml \
    --ntp-server 94.229.74.162;
