#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
    sudo sh -c 'cat /home/stack/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'
fi

if [ ! -f quickstart.sh ]; then
    wget https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh;
    chmod +x quickstart.sh;
fi

~/quickstart.sh --install-deps;
~/quickstart.sh --bootstrap -R master-tripleo-ci 127.0.0.2;
