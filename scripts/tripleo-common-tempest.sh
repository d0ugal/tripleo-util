#!/bin/bash
set -eux
set -o pipefail

wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
sudo pip install -U setuptools pip virtualenv tox git-review;

git clone http://github.com/d0ugal/tripleo-common-tempest-plugin;
pushd tripleo-common-tempest-plugin;
tox;
popd
rm -rf tripleo-common-tempest-plugin;
