#!/bin/bash
set -eux
set -o pipefail

ROOT=${TRIPLEO_ROOT:-$HOME/code}
mkdir -p $ROOT

PROJ=$1
REVIEW=${2:-""}


# Clone the repo if it doesn't yet exist
if [ ! -d $TRIPLEO_ROOT/$PROJ ]; then
    echo "Cloning the repo..."
    git clone https://git.openstack.org/openstack/$PROJ.git $TRIPLEO_ROOT/$PROJ
fi

if [ ! -z $REVIEW ]; then
    echo "Getting review...";
    pushd $TRIPLEO_ROOT/$PROJ;
    git review -d $REVIEW;
    git show -s;
    popd;
else
    echo "Installing checked out version..."
    pushd $TRIPLEO_ROOT/$PROJ;
    git show -s;
    popd;
fi
