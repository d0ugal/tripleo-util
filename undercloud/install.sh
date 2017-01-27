#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

sudo yum upgrade -y;
sudo yum install -y ack vim wget;
sudo yum install -y libffi-devel libssl-devel openssl-devel python-devel;

rm -rf ~/tripleo-ci
git clone https://github.com/openstack-infra/tripleo-ci.git ~/tripleo-ci

wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
sudo pip install -IU virtualenv setuptools git-review;

~/tripleo-ci/scripts/tripleo.sh --repo-setup
~/tripleo-ci/scripts/tripleo.sh --undercloud
~/tripleo-ci/scripts/tripleo.sh --overcloud-images
~/tripleo-ci/scripts/tripleo.sh --delorean-setup

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"
git config --global --add gitreview.username "dougal"
