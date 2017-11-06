#!/bin/bash
set -eux
set -o pipefail

echo  "Loading actions...";
sudo mistral-db-manage populate
# make sure the new actions got loaded
mistral action-list | grep tripleo
