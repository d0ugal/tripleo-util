#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

if [ -f build/multinode_hosts ]; then
    export $(awk '/subnode-0/ {print $2}' build/multinode_hosts);
else
    export $(awk '/subnode-0/ {print $2}' build/ovb_hosts);
fi;

ssh-keygen -R $ansible_host
rsync -arvce "ssh -o StrictHostKeyChecking=no" -r ~/scripts zuul@$ansible_host:~/
