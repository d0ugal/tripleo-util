#!/bin/bash
set -eux
set -o pipefail

echo "INSTALLING mistralclient";
cd ~/python-mistralclient;
sudo rm -Rf /usr/lib/python2.7/site-packages/mistralclient/;
sudo python setup.py install;
