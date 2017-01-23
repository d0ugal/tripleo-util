#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

sudo yum install -y yum-utils;

rm -rf ~/tripleo-ci
git clone https://github.com/openstack-infra/tripleo-ci.git ~/tripleo-ci

~/tripleo-ci/scripts/tripleo.sh --repo-setup

sudo yum install -y epel-release instack-undercloud
