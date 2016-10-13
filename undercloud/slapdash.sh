#!/bin/bash
{
  ~/tripleo-util/update.sh;
} &> /dev/null

set -ux

openstack stack list  | cut -c 1-230;
mistral execution-list  | cut -c 1-230;
mistral action-execution-list  | cut -c 1-230;
openstack overcloud plan list  | cut -c 1-230;
swift list overcloud | grep user-;
mistral environment-get overcloud  | cut -c 1-230;
