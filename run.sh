#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

dt="$(date "+%Y-%m-%d_%H-%M_%s")";

echo "Running quickstart"

# We want the root user to have the same keys as us.
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '';
fi
sudo rm -rf /root/.ssh;
sudo cp -r ~/.ssh/ /root/.ssh && sudo chown -R root /root/.ssh;

source openrc.sh;
bash ~/clean.sh;

export WORKSPACE="$(mktemp -d -p ~/reproduce/ -t tmp.XXXXX)"
export CREATE_VIRTUALENV=false
export REMOVE_STACKS_KEYPAIRS=false
export NODESTACK_PREFIX=""

unbuffer bash ~/run-new.sh 2>&1 | tee -a logs/$dt.run.log;
