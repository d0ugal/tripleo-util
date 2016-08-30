#!/bin/bash
set -eux
set -o pipefail

rm -rf ~/venv;
virtualenv ~/venv;
~/venv/bin/pip install --editable ~/python-tripleoclient;
~/venv/bin/pip install -r ~/python-tripleoclient/requirements.txt
~/venv/bin/pip install git+git://github.com/openstack/tripleo-common.git@master
