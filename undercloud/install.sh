#!/bin/bash
set -eux
set -o pipefail

sudo yum install -y wget python-dev gcc vim;

if [ ! -f ~/get-pip.py ]; then
    wget https://bootstrap.pypa.io/get-pip.py;
    sudo python get-pip.py;
    sudo pip install -IU virtualenv git-review;
fi

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"
git config --global --add gitreview.username "dougal"

virtualenv ~/venv

~/tripleo-util/dotfiles/install.sh
