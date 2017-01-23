#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

sudo yum install -y yum-utils;

rm -rf ~/tripleo-ci
git clone https://github.com/openstack-infra/tripleo-ci.git ~/tripleo-ci

~/tripleo-ci/scripts/tripleo.sh --repo-setup

sudo yum install -y epel-release instack-undercloud

wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
sudo pip install -IU virtualenv setuptools git-review;

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"
git config --global --add gitreview.username "dougal"
