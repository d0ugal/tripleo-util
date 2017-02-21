#!/bin/bash
set -eux
set -o pipefail

sudo yum install -y wget python-dev gcc vim;

if [ -d ~/tripleo-ci ]; then
    rm -rf ~/tripleo-ci;
fi

git clone https://github.com/openstack-infra/tripleo-ci.git;
~/tripleo-ci/scripts/tripleo.sh --delorean-setup;

if [ ! -f ~/get-pip.py ]; then
    wget https://bootstrap.pypa.io/get-pip.py;
    sudo python get-pip.py;
    sudo pip install -IU virtualenv setuptools git-review;
fi

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"
git config --global --add gitreview.username "dougal"

mkdir -p ~/code;
pushd ~/code;
if [ ! -d python-tripleodash ]; then
    git clone https://github.com/d0ugal/python-tripleodash.git;
fi
popd;

virtualenv ~/venv

~/tripleo-util/undercloud/tripleodash-install.sh
~/tripleo-util/dotfiles/install.sh
