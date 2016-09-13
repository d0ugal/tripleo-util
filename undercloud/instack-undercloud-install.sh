#!/bin/bash
set -eux
set -o pipefail

echo "INSTALLING instack-undercloud";
cd ~/instack-undercloud;
sudo rm -Rf /usr/lib/python2.7/site-packages/instack-undercloud*
sudo python setup.py install;
