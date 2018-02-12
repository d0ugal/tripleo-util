#!/bin/bash
set -eux
set -o pipefail

export $(awk '/subnode-0/ {print $2}' reproduce/multinode_hosts); ssh zuul@$ansible_host
