#!/bin/bash
set -eux
set -o pipefail

~/venv/bin/openstack overcloud deploy --templates \
-e ~/tripleo-util/testenvs/user_defined_passwords/user_passwords.yaml \
--debug
