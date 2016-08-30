#!/bin/bash
set -eux
set -o pipefail

~/venv/bin/openstack overcloud deploy --templates \
-e ~/tripleo-util/test-scenarios/local_resource_registry/wait_env.yaml \
--debug
