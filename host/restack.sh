#!/bin/bash -xe

if [[ $USER != "stack" ]]; then
  echo "Must be run as stack user.";
	exit 1;
fi

sudo virsh destroy instack || true;
sudo virsh undefine instack || true;
virsh destroy instack || true;
virsh undefine instack || true;

export NODE_DIST=centos7;
export NODE_CPU=4;
export NODE_MEM=16384;
export UNDERCLOUD_NODE_CPU=4;
export UNDERCLOUD_NODE_MEM=16384;
export NODE_COUNT=3;
instack-virt-setup;
