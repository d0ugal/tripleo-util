#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

export $(awk '/subnode-0/ {print $2}' reproduce/multinode_hosts);

ssh-keygen -R $ansible_host
rsync -arvce "ssh -o StrictHostKeyChecking=no" -r ~/scripts zuul@$ansible_host:~/
rsync -arvce "ssh -o StrictHostKeyChecking=no" -r zuul@$ansible_host:~/scripts ~/
