#!/bin/bash -xe

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

rm -rf ~/tripleo-ci
git clone https://github.com/openstack-infra/tripleo-ci.git ~/tripleo-ci

export DELOREAN_REPO_URL="http://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-master-tripleo/"
export DELOREAN_STABLE_REPO_URL="http://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-$STABLE_RELEASE/"

~/tripleo-ci/scripts/tripleo.sh --repo-setup

sudo yum install -y instack-undercloud
