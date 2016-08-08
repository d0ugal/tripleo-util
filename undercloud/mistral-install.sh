#!/bin/bash
set -eu
set -o pipefail

echo "INSTALLING tripleo-common";
cd ~/tripleo-common;
sudo rm -Rf /usr/lib/python2.7/site-packages/tripleo_common*
sudo python setup.py install
sudo systemctl restart openstack-mistral-*;
sleep 10;

# this loads the actions via entrypoints
echo  "LOADING ACTIONS";
sudo mistral-db-manage populate
# make sure the new actions got loaded
mistral action-list | grep tripleo

echo "LOADING workbooks"
for workbook in $(mistral workbook-list | grep tripleo | cut -f 2 -d ' '); do
    mistral workbook-delete $workbook
done
for workflow in $(mistral workflow-list | grep tripleo | cut -f 2 -d ' '); do
    mistral workflow-delete $workflow
done
for workbook in $(ls ~/tripleo-common/workbooks/*); do
    mistral workbook-create $workbook
done
