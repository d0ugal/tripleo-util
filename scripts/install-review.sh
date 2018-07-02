#!/bin/bash
set -eux
set -o pipefail

id=$1
url="https://review.openstack.org/changes/?q=$id&o=DOWNLOAD_COMMANDS&o=CURRENT_REVISION"
# Because gerrit hates users...
json=$(curl -s $url | sed 's/^.\{4\}//g');
git_url=$(echo $json | jq ".[0].revisions[.[0].current_revision].fetch.\"anonymous http\".url" -r);
git_command=$(echo $json | jq ".[0].revisions[.[0].current_revision].fetch.\"anonymous http\".commands.Checkout" -r);
IFS='&' read -a git_command_parts <<< $git_command;

cd $(mktemp -d);
git clone $git_url repo;
cd repo;
${git_command_parts[0]} && ${git_command_parts[2]};
sudo pip install --no-deps .;
