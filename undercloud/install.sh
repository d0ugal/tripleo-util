#!/bin/bash
set -eux
set -o pipefail

sudo yum install -y python-virtualenv

if [ ! -f ~/venv ]; then
    virtualenv ~/venv
fi

source ~/venv/bin/activate
pip install -U pip

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"
git config --global --add gitreview.username "dougal"

~/tripleo-util/dotfiles/install.sh
