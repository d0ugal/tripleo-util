#!/bin/bash
set -eux
set -o pipefail

TRIPLEO_ROOT="~"
~/venv/bin/openstack overcloud deploy \
    --templates=$TRIPLEO_ROOT/tripleo-heat-templates \
    -e $TRIPLEO_ROOT/tripleo-heat-templates/environments/network-isolation.yaml \
    -e $TRIPLEO_ROOT/tripleo-heat-templates/environments/net-single-nic-with-vlans.yaml \
    -e $TRIPLEO_ROOT/tripleo-heat-templates/environments/puppet-pacemaker.yaml \
    -e $TRIPLEO_ROOT/tripleo-heat-templates/environments/puppet-ceph-devel.yaml \
    -e $TRIPLEO_ROOT/tripleo-heat-templates/environments/mongodb-nojournal.yaml \
    # -e $TRIPLEO_ROOT/custom.yaml \
    --ntp-server 94.229.74.162
