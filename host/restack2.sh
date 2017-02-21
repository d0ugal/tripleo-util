#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "heap" ]]; then
    echo "Must be run as heap user.";
    exit 1;
fi

# http://i1.kym-cdn.com/photos/images/facebook/000/511/991/3a5.jpg
rm -rf ~/*;
git clone https://github.com/d0ugal/tripleo-util.git;
~/tripleo-util/host/install.sh;
