#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

dt="$(date "+%Y-%m-%d_%H-%M_%s")";

echo "Running quickstart";

URL=$1;

bash ~/clean.sh;

source openrc.sh;
WORKSPACE="$(mktemp -d -p ~/reproduce/ -t tmp.XXXXX)";

rm -f reproducer-quickstart.sh;
wget $URL;

unbuffer bash -x reproducer-quickstart.sh \
  --workspace $WORKSPACE \
  --create-virtualenv true \
  --remove-stacks-keypairs true \
  --nodestack-prefix reproi 2>&1 \
  | tee -a logs/$dt.run.log;
