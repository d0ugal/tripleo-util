#!/bin/bash
set -ux

swift delete overcloud;
mistral environment-delete overcloud;
~/tripleo-ci/scripts/tripleo.sh --overcloud-delete;
~/tripleo-util/undercloud/mistral-purge.sh;
