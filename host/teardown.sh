#!/bin/bash
set -eux
set -o pipefail

~/quickstart.sh --teardown all 127.0.0.2 || true;
