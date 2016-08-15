#!/bin/bash
set -eux
set -o pipefail

swift delete overcloud;
mistral environment-delete overcloud;
~/tripleo-util/undercloud/mistral-purge.sh;
~/tripleo-ci/scripts/tripleo.sh --overcloud-delete;
