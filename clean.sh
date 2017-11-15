#!/bin/bash
set -eux
set -o pipefail

if [ ! -f /.dockerenv ]; then
    echo "This should be run within the container";
    exit 0;
fi

# We want the root user to have the same keys as us.
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '';
fi
sudo rm -rf /root/.ssh;
sudo cp -r ~/.ssh/ /root/.ssh && sudo chown -R root /root/.ssh;

dt="$(date "+%Y-%m-%d_%H-%M_%s")";

rm -rf ~/tripleo-quickstart;
rm -rf ~/.quickstart ;

git clone https://github.com/openstack/tripleo-quickstart.git ~/tripleo-quickstart;

unbuffer bash ~/tripleo-quickstart/quickstart.sh --install-deps 2>&1 | tee -a logs/$dt.install.log;
