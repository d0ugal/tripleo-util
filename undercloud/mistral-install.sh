#!/bin/bash
set -eux
set -o pipefail

echo "INSTALLING mistral";
cd ~/mistral;
sudo rm -Rf /usr/lib/python2.7/site-packages/mistral*
sudo python setup.py install;
cd ~/tripleo-common;
sudo systemctl restart openstack-mistral-*;
sleep 10;

# this loads the actions via entrypoints
echo  "LOADING ACTIONS";
sudo mistral-db-manage populate
# make sure the new actions got loaded
mistral action-list | grep tripleo

~/tripleo-util/undercloud/mistral-install-workbooks.sh;
