#!/bin/bash
set -eux
set -o pipefail

cd "$(dirname "$0")";

PWD=${PWD};

docker build . -t lab;
docker run \
    --user heap \
    -it -v $PWD:/home/heap/ \
    lab
