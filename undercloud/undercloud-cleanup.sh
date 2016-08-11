#!/bin/bash
set -eux
set -o pipefail

swift delete overcloud;
mistral environment-delete overcloud;
~/tripleo-ci/scripts/tripleo.sh --overcloud-delete;
