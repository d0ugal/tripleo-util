#!/bin/bash

# See documentation for using the reproducer script:
# README-reproducer-quickstart.html
# (in the same top-level logs directory as this reproducer script).

: ${WORKSPACE:=$(mktemp -d -p ~ -t reproduce-tmp.XXXXX)}
: ${CREATE_VIRTUALENV:=false}
: ${REMOVE_STACKS_KEYPAIRS:=false}
: ${NODESTACK_PREFIX:=""}

usage () {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -w, --workspace <dir>"
    echo "                      directory where the virtualenv, inventory files, etc."
    echo "                      are created. Defaults to creating a directory in /tmp"
    echo "  -v, --create-virtualenv"
    echo "                      create a virtualenv to install Ansible and dependencies."
    echo "                      Options to pass true/false. Defaults to true for OVB. "
    echo "                      Defaults to false for other deployment types."
    echo "  -r, --remove-stacks-keypairs"
    echo "                      delete all Heat stacks (both Multinode and OVB created) "
    echo "                      in the tenant before deployment."
    echo "                      Will also delete associated keypairs if they exist."
    echo "                      Options to pass true/false.Defaults to false."
    echo "  -p, --nodestack-prefix"
    echo "                      add a unique prefix for multinode and singlenode stacks"
    echo "                      Defaults to empty."
    echo "  -h, --help          print this help and exit"
}

set -e

# Check that tenant credentials have been sourced
if [[ ! -v OS_TENANT_NAME ]]; then
    echo "Tenant credentials are not sourced."
    exit 1;
fi

# Input argument assignments
while [ "x$1" != "x" ]; do

    case "$1" in
        --workspace|-w)
            WORKSPACE=$(realpath $2)
            shift
            ;;

        --create-virtualenv|-v)
            CREATE_VIRTUALENV=$2
            shift
            ;;

        --remove-stacks-keypairs|-r)
            REMOVE_STACKS_KEYPAIRS=$2
            shift
            ;;

        --nodestack-prefix|-p)
            NODESTACK_PREFIX=$2
            shift
            ;;

        --help|-h)
            usage
            exit
            ;;

        --) shift
            break
            ;;

        -*) echo "ERROR: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;

        *)    break
            ;;
    esac

    shift
done

set -x
# Exit if running ovb-fakeha-caserver
# This test is not converted to run with tripleo-quickstart
export TOCI_JOBTYPE="multinode-1ctlr-featureset010"
if [[ "$TOCI_JOBTYPE" == *"ovb-fakeha-caserver"* ]]; then
    echo "
        ovb-fakeha-caserver is not run with tripleo-quickstart.
        It can not be reproduced using this script.
    "
    exit 1;
fi

# Start from a clean workspace
export WORKSPACE
cd $WORKSPACE
rm -rf tripleo-quickstart tripleo-quickstart-extras

# Clone quickstart and quickstart-extras
git clone https://github.com/openstack/tripleo-quickstart
git clone https://github.com/openstack/tripleo-quickstart-extras

# Set up a virtual env if requested
if [ "$CREATE_VIRTUALENV" = "true" ]; then
    virtualenv --system-site-packages $WORKSPACE/venv_ansible
    source $WORKSPACE/venv_ansible/bin/activate
    pip install --upgrade setuptools pip
    pip install -r $WORKSPACE/tripleo-quickstart/requirements.txt
fi

if [ "$REMOVE_STACKS_KEYPAIRS" = "true" ]; then
    # The cleanup templates expects there to be in a /bin dir in the workspace # from quickstart setup.
    # To use the clients sourced from venv
    sed -i "s#{.*/bin/##g" $WORKSPACE/tripleo-quickstart-extras/roles/ovb-manage-stack/templates/cleanup-stacks-keypairs.sh.j2
fi

# Export ZUUL_CHANGES in the Ansible host if there are changes in
# tripleo-quickstart, tripleo-quickstart-extras or tripleo-ci repos
# before running playbooks
export ZUUL_CHANGES="openstack/python-tripleoclient:master:refs/changes/53/526653/11"

# Export our roles path so that we can use the roles from our workspace
export ANSIBLE_ROLES_PATH=$ANSIBLE_ROLES_PATH:$WORKSPACE/tripleo-quickstart/roles:$WORKSPACE/tripleo-quickstart-extras/roles

# Export a node config for the topology you need ie:
export NODES_FILE="$WORKSPACE/tripleo-quickstart/config/nodes/1ctlr.yml"


# Calculate subnode_count
if  [[ -z "$NODES_FILE" ]]; then
    SUBNODE_COUNT=1
else
    SUBNODE_COUNT=$(( $( awk '/node_count: / {print $2}' $NODES_FILE ) +1 ))
fi

ansible-playbook $WORKSPACE/tripleo-quickstart-extras/playbooks/provision_multinodes.yml \
    -e local_working_dir=$WORKSPACE \
    -e subnode_count=$SUBNODE_COUNT \
    -e prefix=$NODESTACK_PREFIX

# Run the playbook to setup the undercloud/subnodes to look like nodepool nodes
ansible-playbook -i $WORKSPACE/multinode_hosts $WORKSPACE/tripleo-quickstart-extras/playbooks/nodepool-setup.yml

# Get ansible_host
export $(awk '/subnode-0/ {print $2}' multinode_hosts)


# Create the env_vars_to_source file and copy it to the undercloud
cat >"env_vars_to_src.sh" <<EOF
export ZUUL_CHANGES="openstack/python-tripleoclient:master:refs/changes/53/526653/11"
export NODES_FILE="$WORKSPACE/tripleo-quickstart/config/nodes/1ctlr.yml"
export TOCI_JOBTYPE="multinode-1ctlr-featureset010"
export EXTRA_VARS="$EXTRA_VARS --extra-vars dlrn_hash_tag=c8cceebf8e648ce46219026f926047491135a66e_fcf8d179 "
EOF



scp "$WORKSPACE/env_vars_to_src.sh" zuul@$ansible_host:/home/zuul/

# Remove -x so that the instructions don't print twice
set +x

# Instruct the user to execute toci_gate_test-oooq.sh on the undercloud
echo "
    Now complete the test excution on the undercloud:
    - ssh to the undercloud: $ ssh zuul@$ansible_host
    - Source the environment settings file: $ source /home/zuul/env_vars_to_src.sh
    - Run the toci gate script: $ /opt/stack/tripleo-ci/toci_gate_test-oooq.sh

    To avoid timeouts, you can start a screen session before executing the commands: $ screen -S ci
"
