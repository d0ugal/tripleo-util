#!/bin/bash
set -eux
set -o pipefail

~/scripts/mistral-delete-executions.sh;

create="openstack workflow execution create -c ID -f value";
show="openstack workflow execution show";
state="$show -c State -f value"
wf="tripleo.messaging.v1.send"

wait_for_execution(){
    ex_state=$($state $1);
    while [ "$ex_state" != "SUCCESS"  ] && [ "$ex_state" != "ERROR"  ]; do
      ex_state=$($state $1);
    done
    ~/scripts/wf-report $1;
    $show $1;
    sleep 10;
}

swift delete overcloud-messages || true;

json='{"type": "test", "queue_name": "tripleo", "plan_name": "overcloud", "execution": {"id": "UUID"}, "plan_status": "statusseses"}';
ex_id=$($create $wf "$json" -d "Plan name and status. No container");
wait_for_execution $ex_id;

json='{"type": "test", "queue_name": "tripleo", "plan_name": "overcloud", "execution": {"id": "UUID"}, "plan_status": "statusseses"}';
ex_id=$($create $wf "$json" -d "Plan name and status. container exists");
wait_for_execution $ex_id;

json='{"type": "test", "queue_name": "tripleo", "plan_name": "overcloud", "execution": {"id": "UUID"}}';
ex_id=$($create $wf "$json" -d "Plan name, no status.");
wait_for_execution $ex_id;

json='{"type": "test", "queue_name": "tripleo", "execution": {"id": "UUID"}}';
ex_id=$($create $wf "$json" -d "No plan or status");
wait_for_execution $ex_id;

json='{"type": "test", "queue_name": "tripleo", "execution": {"id": "UUID"}, "plan_status": "status"}';
ex_id=$($create $wf "$json" -d "Plan status but no plan name");
wait_for_execution $ex_id;
