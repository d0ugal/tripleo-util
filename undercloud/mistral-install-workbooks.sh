#!/bin/bash
set -eu
set -o pipefail

for workbook in $(mistral workbook-list | grep tripleo | cut -f 2 -d ' '); do
    mistral workbook-delete $workbook
done
for workflow in $(mistral workflow-list | grep tripleo | cut -f 2 -d ' '); do
    mistral workflow-delete $workflow
done
for workbook in $(ls ~/tripleo-common/workbooks/*); do
    mistral workbook-create $workbook
done
