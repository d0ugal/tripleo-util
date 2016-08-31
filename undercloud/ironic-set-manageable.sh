#!/bin/bash
set -eux
set -o pipefail

exec_ids=$(openstack baremetal list | awk -F "| " '{print $2; }')
for exec_id in $exec_ids; do
  if [ ! $exec_id = "UUID" ]; then
    ironic node-set-provision-state $exec_id manage;
  fi
done

ironic node-list;
