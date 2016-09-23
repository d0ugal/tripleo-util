#!/bin/bash
set -eux
set -o pipefail

echo "INSTALLING mistral";
cd ~/mistral;
sudo rm -Rf /usr/lib/python2.7/site-packages/mistral/;
sudo python setup.py install;
cd ~/tripleo-common;
sudo systemctl restart openstack-mistral-*;
sleep 3;
