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

# We want the root user to have the same keys as us.
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '';
fi
sudo rm -rf /root/.ssh;
sudo cp -r ~/.ssh/ /root/.ssh && sudo chown -R root /root/.ssh;

bash ~/clean.sh;

source openrc.sh;
WORKSPACE="$(mktemp -d -p ~/reproduce/ -t tmp.XXXXX)";

rm -f reproducer-quickstart.sh;
wget $URL;

bash -x reproducer-quickstart.sh \
  --workspace WORKSPACE \
  --create-virtualenv true \
  --remove-stack-keypairs true \
  --nodestack-prefix repro;
