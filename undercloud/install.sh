#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

sudo yum install -y wget;

git clone https://github.com/openstack-infra/tripleo-ci.git;

wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
sudo pip install -IU virtualenv setuptools git-review;

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"
git config --global --add gitreview.username "dougal"

mkdir -p ~/code;
pushd ~/code;
git clone https://github.com/d0ugal/python-tripleodash.git
popd;

virtualenv ~/venv

~/tripleo-util/undercloud/tripleodash-install.sh
~/tripleo-util/dotfiles/install.sh
