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
WORKSPACE=~/build

bash ~/clean-all.sh;

source openrc.sh;
rm -rf $WORKSPACE && mkdir -p $WORKSPACE;

rm -f $WORKSPACE/reproducer-quickstart.sh
wget $URL -O $WORKSPACE/reproducer-quickstart.sh;
cp $WORKSPACE/reproducer-quickstart.sh logs/$dt.sh;


bash -x $WORKSPACE/reproducer-quickstart.sh \
  --workspace $WORKSPACE \
  --create-virtualenv true \
  --remove-stacks-keypairs true \
  --autorun;
