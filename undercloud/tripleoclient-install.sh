#!/bin/bash
set -eux
set -o pipefail

rm -rf ~/venv;
virtualenv ~/venv;
~/venv/bin/pip install --editable ~/python-tripleoclient;
~/venv/bin/pip install tripleo-common==5.0.0.0b2 os-cloud-config==5.0.0.0b2
~/venv/bin/pip install -UI os-client-config>=1.13.1,!=1.19.0,!=1.19.1,!=1.20.0
