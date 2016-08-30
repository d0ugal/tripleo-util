#!/bin/bash
set -eux
set -o pipefail

~/venv/bin/openstack overcloud deploy --templates \
-e ~/tripleo-util/test-scenarios/combine_parameter_defaults/ceph_osd_on_compute.yaml \
--debug
