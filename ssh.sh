#!/bin/bash
set -eux
set -o pipefail

ssh -F .quickstart/ssh.config.ansible undercloud -i .quickstart/id_rsa_undercloud
