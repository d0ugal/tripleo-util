#!/bin/bash
set -eu
set -o pipefail

exec_ids=$(mistral execution-list | awk -F "| " '{print $2; }')
for exec_id in $exec_ids; do
  echo $exec_id;
done
