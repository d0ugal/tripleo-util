#!/bin/bash -xe

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

rm -rf ~/tripleo-quickstart;
git clone https://github.com/openstack/tripleo-quickstart.git ~/tripleo-quickstart;

bash ~/tripleo-quickstart/quickstart.sh --install-deps;
bash ~/tripleo-quickstart/quickstart.sh \
    --extra-vars @config/general_config/devmode.yml \
    --release master \
    localhost;
