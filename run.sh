#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

dt="$(date "+%Y-%m-%d_%H-%M_%S")";

unbuffer bash -x wrapped.sh $1 $2 2>&1 | awk '{ print strftime(), $0; fflush() }' | tee -a logs/$1-$dt.run.log;
