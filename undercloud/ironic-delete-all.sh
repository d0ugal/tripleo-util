#!/bin/bash
set -eux
set -o pipefail

exec_ids=$(openstack baremetal list | awk -F "| " '{print $2; }')
for exec_id in $exec_ids; do
  if [ ! $exec_id = "UUID" ]; then
    ironic node-delete $exec_id;
  fi
done
