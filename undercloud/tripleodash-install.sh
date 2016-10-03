#!/bin/bash
set -eux
set -o pipefail

rm -rf ~/venv-dash;
virtualenv ~/venv-dash;
~/venv-dash/bin/pip install --editable ~/python-tripleodash;
