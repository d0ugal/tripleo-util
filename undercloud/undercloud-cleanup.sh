#!/bin/bash
set -ux

swift delete overcloud;
mistral environment-delete overcloud;
~/tripleo-util/undercloud/mistral-purge.sh;
~/tripleo-ci/scripts/tripleo.sh --overcloud-delete;
