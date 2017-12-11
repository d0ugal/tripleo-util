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

# If we don't have the quickstart dir, call the clean script which will clean
# up previous versions and setup.
if [ ! -d ~/tripleo-quickstart/ ]; then
    bash ~/clean.sh;
fi

source openrc.sh;
export WORKSPACE=$HOME/.quickstart;

export ZUUL_HOST='review.openstack.org';
# to split changes: ^
export ZUUL_CHANGES='openstack/tripleo-common:master:refs/changes/62/526462/3';

# Mistral in the overcloud
#export OPT_ADDITIONAL_PARAMETERS=" --extra-vars @config/general_config/featureset007.yml";

#unbuffer bash ~/tripleo-quickstart/devmode.sh -d --ovb --no-gate 2>&1 | tee -a logs/$dt.run.log;
unbuffer bash ~/tripleo-quickstart/devmode.sh -d --ovb 2>&1 | tee -a logs/$dt.run.log;
