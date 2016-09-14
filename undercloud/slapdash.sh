#!/bin/bash
{
  ~/tripleo-util/update.sh;
} &> /dev/null

set -ux

openstack stack list;
mistral execution-list;
mistral action-execution-list;
openstack overcloud plan list;
swift list overcloud | grep user-;
mistral environment-get overcloud  | cut -c 1-230;
