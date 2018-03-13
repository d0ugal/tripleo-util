#!/bin/bash
set -eux
set -o pipefail

export $(awk '/subnode-0/ {print $2}' reproduce/multinode_hosts);

ssh-keygen -R $ansible_host
ssh -o StrictHostKeyChecking=no zuul@$ansible_host -i .ssh/id_rsa
