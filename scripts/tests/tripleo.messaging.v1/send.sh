#!/bin/bash
set -eux
set -o pipefail

~/scripts/mistral-delete-executions.sh;

create="openstack workflow execution create -c ID -f value";
show="openstack workflow execution show";
state="$show -c State -f value"
wf="tripleo.messaging.v1.send"

_run_and_wait(){

    ex_id=$($create $wf "$2" -d "$1");
    ex_state=$($state $ex_id);
    while [ "$ex_state" != "SUCCESS"  ] && [ "$ex_state" != "ERROR"  ]; do
      ex_state=$($state $ex_id);
    done
    ~/scripts/wf-report $ex_id;
    $show $ex_id;
    swift list overcloud-messages || true;
    if [ "$ex_state" != "$3" ]; then
      echo "Execution failed";
      exit 42;
    fi
}

run_and_wait(){
    expected=${3:-SUCCESS};
    # Delete the container
    swift delete overcloud-messages || true;
    # Run once without
    _run_and_wait "$1 (No container)" "$2" $expected;
    # and once with
    _run_and_wait "$1 (With container)" "$2" $expected;
}

run_and_wait \
  "Plan name and status." \
  '{"type": "test", "queue_name": "tripleo", "plan_name": "overcloud", "execution": {"id": "UUID"}, "plan_status": "statusseses"}';

run_and_wait \
  "Plan name, no status." \
  '{"type": "test", "queue_name": "tripleo", "plan_name": "overcloud", "execution": {"id": "UUID"}}';

run_and_wait \
  "No plan or status" \
  '{"type": "test", "queue_name": "tripleo", "execution": {"id": "UUID"}}';

run_and_wait \
  "Plan status but no plan name" \
  '{"type": "test", "queue_name": "tripleo", "execution": {"id": "UUID"}, "plan_status": "status"}';

run_and_wait \
  "failure message" \
  '{"type": "test", "queue_name": "tripleo", "status": "FAILED", "execution": {"id": "UUID"}, "plan_status": "status"}' \
  "ERROR";
