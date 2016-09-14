#!/bin/bash
set -eux
set -o pipefail

openstack overcloud deploy \
    --templates \
    -e ~/tripleo-heat-templates/environments/puppet-pacemaker.yaml \
    -e ~/tripleo-heat-templates/environments/storage-environment.yaml \
    -e ~/tripleo-heat-templates/environments/ceph-radosgw.yaml \
    --ceph-storage-scale 1 \
    --debug;
