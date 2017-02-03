#!/bin/bash

pushd ~/tripleo-util;
git fetch --all;
git reset origin/master --hard;
popd;

~/tripleo-util/dotfiles/install.sh;
