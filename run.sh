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

# If you want to update quickstart, delete ~/tripleo-quickstart and it'll
# re-clone and remove the old workdir.
if [ ! -d ~/tripleo-quickstart/ ]; then
    git clone https://github.com/openstack/tripleo-quickstart.git ~/tripleo-quickstart;
    rm -rf ~/.quickstart ;
    unbuffer bash ~/tripleo-quickstart/quickstart.sh --install-deps 2>&1 | tee -a logs/$dt.install.log;
fi

source openrc.sh;

export ZUUL_HOST='review.openstack.org';
export WORKSPACE=$HOME/.quickstart;
# to split changes: ^
export ZUUL_CHANGES='openstack/mistral:master:refs/changes/61/513061/9';

# Mistral in the overcloud
#export OPT_ADDITIONAL_PARAMETERS=" --extra-vars @config/general_config/featureset007.yml";

unbuffer bash ~/tripleo-quickstart/devmode.sh -d --ovb 2>&1 | tee -a logs/$dt.run.log;
