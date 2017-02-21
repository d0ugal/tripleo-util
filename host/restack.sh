#!/bin/bash
set -eux
set -o pipefail

~/tripleo-util/host/teardown.sh;
~/tripleo-util/host/install.sh;
