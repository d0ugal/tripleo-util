#!/bin/bash
set -eux
set -o pipefail

openstack messaging message list tripleo --client-id=de305d54-75b4-431b-adb2-eb6b9e546014;
