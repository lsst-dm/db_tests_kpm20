#!/bin/bash
#
# NOTE: This script is meant to be run on the development node ccqservbuild

# create_database.bash


set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

echo $WORKERS

#create the database on the workers.
for node in $WORKERS; do
    ssh -n $node $SCRIPTS/create_database.bash >& $QSERV_LOCAL_LOG_DIR/${node}_create_database.log &
done

#create the database on the czar
node=${MASTER}
ssh -n $node $SCRIPTS/create_database.bash >& $QSERV_LOCAL_LOG_DIR/${node}_create_database.log &
