#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

TRIPLEO_ROOT=${TRIPLEO_ROOT:-$HOME/tripleo}

PROJ=$1
REVIEW=$2


# Clone the repo if it doesn't yet exist
if [ ! -d $TRIPLEO_ROOT/$PROJ ]; then
    git clone https://git.openstack.org/openstack/$PROJ.git $TRIPLEO_ROOT/$PROJ
fi

pushd $TRIPLEO_ROOT/$PROJ;
git review -d $REVIEW;
popd;

~/tripleo-ci/scripts/tripleo.sh --delorean-build openstack/$PROJ;

sudo yum install -y ~/tripleo/delorean/data/repos/*/*/*/*$PROJ*.noarch.rpm
