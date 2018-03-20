#!/bin/bash
set -eux
set -o pipefail

if [ -f reproduce/multinode_hosts ]; then
    export $(awk '/subnode-0/ {print $2}' reproduce/multinode_hosts);
else
    export $(awk '/subnode-0/ {print $2}' reproduce/ovb_hosts);
fi;

ssh-keygen -R $ansible_host
ssh -o StrictHostKeyChecking=no zuul@$ansible_host -i .ssh/id_rsa
