#!/bin/bash
set -eux
set -o pipefail

if [ -f /.dockerenv ]; then
    echo "This must be run on a docker host";
    exit 0;
fi

cd "$(dirname "$0")";

PWD=${PWD};

docker build . -t lab;
docker run \
    --user heap \
    -it -v $PWD:/home/heap/ \
    lab
