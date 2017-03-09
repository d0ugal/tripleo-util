#!/bin/bash
set -eux
set -o pipefail

ROOT=${ROOT:-$HOME/code}
mkdir -p $ROOT

PROJ=$1
REVIEW=${2:-""}


# Clone the repo if it doesn't yet exist
if [ ! -d $ROOT/$PROJ ]; then
    echo "Cloning the repo..."
    git clone https://git.openstack.org/openstack/$PROJ.git $ROOT/$PROJ
fi

if [ ! -z $REVIEW ]; then
    echo "Getting review...";
    pushd $ROOT/$PROJ;
    git review -d $REVIEW;
    git show -s;
    popd;
else
    echo "Installing checked out version..."
    pushd $ROOT/$PROJ;
    git show -s;
    popd;
fi
