#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

dt="$(date "+%Y-%m-%d_%H-%M_%S")";

echo "Running quickstart";

if [ $# -lt 2 ]; then
  echo 1>&2 "$0: not enough arguments"
  exit 42
elif [ $# -gt 2 ]; then
  echo 1>&2 "$0: too many arguments"
  exit 42
fi

PREFIX=$1

echo -e '\033k'Reproducer $PREFIX'\033\\'

URL=$2;
WORKSPACE=~/build/$PREFIX

bash ~/clean.sh $PREFIX;

source openrc.sh;
rm -rf $WORKSPACE && mkdir -p $WORKSPACE;

rm -f $PREFIX-reproducer-quickstart.sh;
wget $URL -O $WORKSPACE/$PREFIX-reproducer-quickstart.sh;
cp $WORKSPACE/$PREFIX-reproducer-quickstart.sh logs/$PREFIX-$dt.sh;


bash -x $WORKSPACE/$PREFIX-reproducer-quickstart.sh \
  --workspace $WORKSPACE \
  --create-virtualenv true \
  --remove-stacks-keypairs true \
  --nodestack-prefix repro_${PREFIX}_ \
  --autorun;
