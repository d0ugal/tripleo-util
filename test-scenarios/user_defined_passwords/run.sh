#!/bin/bash
set -eux
set -o pipefail

~/venv/bin/openstack overcloud deploy --templates \
-e ~/tripleo-util/test-scenarios/user_defined_passwords/user_passwords.yaml \
--debug
