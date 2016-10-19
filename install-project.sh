#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

TRIPLEO_ROOT=${TRIPLEO_ROOT:-$HOME/tripleo}

PROJ=$1
REVIEW=${2:-""}


# Clone the repo if it doesn't yet exist
if [ ! -d $TRIPLEO_ROOT/$PROJ ]; then
    echo "Cloning the repo..."
    git clone https://git.openstack.org/openstack/$PROJ.git $TRIPLEO_ROOT/$PROJ
fi

if [ ! -z $REVIEW ] then
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

echo "Installing ^^";

~/tripleo-ci/scripts/tripleo.sh --delorean-build openstack/$PROJ;

sudo yum install -y ~/tripleo/delorean/data/repos/*/*/*/*$PROJ*.noarch.rpm
