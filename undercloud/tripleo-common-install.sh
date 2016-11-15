#!/bin/bash
set -eux
set -o pipefail

echo "Restarting Mistral";
sudo systemctl restart openstack-mistral-*;
sleep 10;

~/tripleo-util/undercloud/mistral-install-actions.sh;
~/tripleo-util/undercloud/mistral-install-workbooks.sh;
