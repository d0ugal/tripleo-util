#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

source ~/stackrc;
~/tripleo-util/undercloud/openstack-register-nodes.sh

mkdir -p ~/code;
pushd ~/code;
git clone https://github.com/d0ugal/python-tripleodash.git
popd;

virtualenv ~/venv

~/tripleo-util/undercloud/tripleodash-install.sh
~/tripleo-util/post-update.sh
