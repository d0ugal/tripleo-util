#!/bin/bash

~/tripleo-util/update.sh;

set -ux

openstack stack list;
mistral execution-list;
mistral action-execution-list;
openstack overcloud plan list;
swift list;
mistral environment-list;
swift list overcloud | grep "user-";
mistral environment-get overcloud;
