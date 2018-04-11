#!/bin/bash
set -eux
set -o pipefail

~/scripts/mistral-delete-executions.sh;

create="openstack workflow execution create -c ID -f value";
show="openstack workflow execution show";
state="$show -c State -f value"
wf="tripleo.swift.v1.container_exists"

run_and_wait(){
    expected=${3:-SUCCESS};

    ex_id=$($create $wf "$2" -d "$1");
    ex_state=$($state $ex_id);
    while [ "$ex_state" != "SUCCESS"  ] && [ "$ex_state" != "ERROR"  ]; do
      ex_state=$($state $ex_id);
    done
    ~/scripts/wf-report $ex_id;
    $show $ex_id;
    swift list;
    if [ "$ex_state" != "$expected" ]; then
      echo "Execution failed";
      exit 42;
    fi
}

swift delete test-container || true;

run_and_wait "No container, No create" '{"container":"test-container"}' 'ERROR';
run_and_wait "No container, Yes create" '{"container":"test-container", "create_container":true}';
run_and_wait "Yes container, No create" '{"container":"test-container"}';
run_and_wait "Yes container, Yes create" '{"container":"test-container", "create_container":true}';

swift delete test-container || true;

run_and_wait "No container, Custom create" '{"container":"test-container", "create_container":true, "create_action": "tripleo.plan.create_container"}';

swift delete test-container || true;
run_and_wait "No container, Custom headers" '{"container":"test-container", "create_container":true, "headers": {"x-container-meta-usage-tripleo": "support"}}';
