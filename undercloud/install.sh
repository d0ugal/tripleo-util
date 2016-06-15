#!/bin/bash -xe

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

sudo yum -y install epel-release
sudo curl -o /etc/yum.repos.d/delorean.repo http://trunk.rdoproject.org/centos7/current-tripleo/delorean.repo
sudo curl -o /etc/yum.repos.d/delorean-current.repo http://trunk.rdoproject.org/centos7/current/delorean.repo
sudo sed -i 's/\[delorean\]/\[delorean-current\]/' /etc/yum.repos.d/delorean-current.repo
sudo /bin/bash -c "cat <<EOF>>/etc/yum.repos.d/delorean-current.repo

includepkgs=diskimage-builder,instack,instack-undercloud,os-apply-config,os-cloud-config,os-collect-config,os-net-config,os-refresh-config,python-tripleoclient,tripleo-common,openstack-tripleo-heat-templates,openstack-tripleo-image-elements,openstack-tripleo,openstack-tripleo-puppet-elements,openstack-puppet-modules
EOF"
sudo curl -o /etc/yum.repos.d/delorean-deps.repo http://trunk.rdoproject.org/centos7/delorean-deps.repo
sudo yum -y install yum-plugin-priorities vim
sudo yum install -y python-tripleoclient
export DIB_INSTALLTYPE_puppet_modules=source
openstack undercloud install

source ~/stackrc
export NODE_DIST=centos7
export USE_DELOREAN_TRUNK=1
export DELOREAN_TRUNK_REPO="http://trunk.rdoproject.org/centos7/current-tripleo/"
export DELOREAN_REPO_FILE="delorean.repo"
export DIB_INSTALLTYPE_puppet_modules=source
openstack overcloud image build --all;
openstack overcloud image upload;

wget https://bootstrap.pypa.io/get-pip.py;
sudo python get-pip.py;
sudo pip install virtualenv git-review;
git clone https://github.com/openstack/python-tripleoclient.git;
git clone https://github.com/openstack/tripleo-common.git;

sudo yum install -y libffi-devel libssl-devel openssl-devel;
