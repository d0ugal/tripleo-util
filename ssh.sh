#!/bin/bash
set -eux
set -o pipefail

if [ -f build/multinode_hosts ]; then
    export $(awk '/subnode-0/ {print $2}' build/multinode_hosts);
else
    export $(awk '/subnode-0/ {print $2}' build/ovb_hosts);
fi;

./sync-scripts.sh

ssh-keygen -R $ansible_host
ssh -o StrictHostKeyChecking=no zuul@$ansible_host -i .ssh/id_rsa
