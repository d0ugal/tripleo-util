#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "heap" ]]; then
    echo "Must be run as heap user.";
    exit 1;
fi

~/quickstart.sh --teardown all 127.0.0.2 || true;
