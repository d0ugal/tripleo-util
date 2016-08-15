#!/bin/bash
set -eux
set -o pipefail

openstack stack list;
mistral execution-list;
mistral action-execution-list;
swift list overcloud;
mistral environment-get overcloud;
