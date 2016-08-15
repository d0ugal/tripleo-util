#!/bin/bash
set -eux
set -o pipefail

~/venv/bin/openstack overcloud deployt --templates \
    -e ~/tripleo-util/local_resource_registry/wait_env.yaml
