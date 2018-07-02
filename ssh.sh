#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

WORKSPACE=~/build;

if [ -f $WORKSPACE/multinode_hosts ]; then
    export $(awk '/subnode-0/ {print $2}' $WORKSPACE/multinode_hosts);
else
    export $(awk '/subnode-0/ {print $2}' $WORKSPACE/ovb_hosts);
fi;

./sync-scripts.sh;

ssh-keygen -R $ansible_host
ssh -o StrictHostKeyChecking=no zuul@$ansible_host -i .ssh/id_rsa
