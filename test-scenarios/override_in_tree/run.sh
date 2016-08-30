#!/bin/bash
set -eux
set -o pipefail

cp /usr/share/openstack-tripleo-heat-templates/puppet/controller.yaml \
 ~/tripleo-util/test-scenarios/override_in_tree/local_controller.yaml

~/venv/bin/openstack overcloud deploy --templates \
-e ~/tripleo-util/test-scenarios/override_in_tree/load_controller_env.yaml \
--debug
