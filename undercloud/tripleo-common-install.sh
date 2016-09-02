#!/bin/bash
set -eux
set -o pipefail

echo "INSTALLING tripleo-common";
sudo rm -Rf /usr/lib/python2.7/site-packages/tripleo_common*
sudo python setup.py install;
sudo systemctl restart openstack-mistral-*;
sleep 10;

# this loads the actions via entrypoints
echo  "LOADING ACTIONS";
sudo mistral-db-manage populate
# make sure the new actions got loaded
mistral action-list | grep tripleo

~/tripleo-util/undercloud/mistral-install-workbooks.sh;
