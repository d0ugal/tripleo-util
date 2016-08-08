#!/bin/bash
set -eux
set -o pipefail

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

sudo yum upgrade -y;
sudo yum install -y vim libffi-devel libssl-devel openssl-devel python-devel;

rm -rf ~/tripleo-ci
git clone https://github.com/openstack-infra/tripleo-ci.git ~/tripleo-ci

export DELOREAN_REPO_URL="http://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-master-tripleo/"
export DELOREAN_STABLE_REPO_URL="http://buildlogs.centos.org/centos/7/cloud/x86_64/rdo-trunk-$STABLE_RELEASE/"

~/tripleo-ci/scripts/tripleo.sh --repo-setup
~/tripleo-ci/scripts/tripleo.sh --undercloud
~/tripleo-ci/scripts/tripleo.sh --overcloud-images

wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
sudo pip install virtualenv git-review;

git config --global user.email "dougal@redhat.com"
git config --global user.name "Dougal Matthews"

git clone https://github.com/openstack/python-tripleoclient.git;
git clone https://github.com/openstack/tripleo-common.git;

virtualenv ~/venv
virtualenv ~/venv-tripleodash;
~/venv-tripleodash/bin/pip install python-tripleodash;
