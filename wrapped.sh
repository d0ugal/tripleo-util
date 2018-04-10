#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

dt="$(date "+%Y-%m-%d_%H-%M_%S")";

echo "Running quickstart";

URL=$1;

bash ~/clean.sh;

source openrc.sh;
rm -rf ~/build/ && mkdir ~/build;
WORKSPACE=~/build/

rm -f reproducer-quickstart.sh;
wget $URL;
cp reproducer-quickstart.sh logs/$dt.sh;


AUTORUN=1 bash -x reproducer-quickstart.sh \
  --workspace $WORKSPACE \
  --create-virtualenv true \
  --remove-stacks-keypairs true \
  --nodestack-prefix repro;
