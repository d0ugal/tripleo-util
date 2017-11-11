#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This must be run within a docker container";
    exit 0;
fi

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
fi

source openrc.sh;

export ZUUL_HOST='review.openstack.org';
export WORKSPACE=$HOME/.quickstart;
# to split changes: ^
export ZUUL_CHANGES='openstack/mistral:master:refs/changes/62/490562/20';
export OPT_ADDITIONAL_PARAMETERS=" --extra-vars @config/general_config/featureset007.yml";

dt="$(date "+%Y-%m-%d_%H-%M_%s")";
bash ~/tripleo-quickstart/quickstart.sh --install-deps 2>&1 | tee -a logs/$dt.log;
bash ~/tripleo-quickstart/devmode.sh -d --ovb 2>&1 | tee -a logs/$dt.log;
