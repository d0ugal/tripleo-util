#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

while true
do
  bash run.sh $1 $2 && break
  sleep 10;
done
