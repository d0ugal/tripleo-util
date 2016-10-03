#!/bin/bash
set -eux
set -o pipefail

openstack overcloud node import ~/instackenv.json --introspect --provide;
