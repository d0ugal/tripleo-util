#!/bin/bash
set -eu
set -o pipefail

exec_ids=$(mistral execution-list | grep -v sub-workflow | awk -F "| " '{print $2; }')
for exec_id in $exec_ids; do
  if [ ! $exec_id = "ID" ]; then
    mistral execution-delete $exec_id
  fi
done

exec_ids=$(mistral action-execution-list | awk -F "| " '{print $2; }')
for exec_id in $exec_ids; do
  if [ ! $exec_id = "ID" ]; then
    mistral action-execution-delete $exec_id
  fi
done
