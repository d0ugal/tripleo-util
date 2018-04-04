#!/bin/bash
set -eux
set -o pipefail

for workbook in $(ls ~/scripts/workbooks/*); do
    mistral workbook-create $workbook || mistral workbook-update $workbook;
done
