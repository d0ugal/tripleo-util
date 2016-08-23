#!/bin/bash
set -eux
set -o pipefail

openstack stack list;
mistral execution-list;
mistral action-execution-list;
swift list;
mistral environment-list;
swift list overcloud | grep "user-";
mistral environment-get overcloud;
