#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
    echo "Must be run as stack user.";
    exit 1;
fi

~/quickstart.sh --teardown all 127.0.0.2 || true;
