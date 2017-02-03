#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sudo sh -c 'cat /home/stack/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'

wget https://raw.githubusercontent.com/openstack/tripleo-quickstart/master/quickstart.sh;
chmod +x quickstart.sh;
./quickstart.sh --install-deps;
./quickstart.sh --bootstrap -R master-tripleo-ci 127.0.0.2;
