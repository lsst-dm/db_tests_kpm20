#!/bin/bash
#
# NOTE: This script is meant to be run on the development node ccqservbuild
# Dump, duplicate, partition Object tables.
# After running this, it will be neccessary to run 2run_ddp_src_only.bash
# and 3run_ddp_fsrc_only.bash. They require the .map file this script generates.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

table="Object"

for node in $WORKERS; do
    ssh -n $node $SCRIPTS/load_stuff.bash ${QSERV_DATA_DIR}/loading${table} ${table} >& $QSERV_LOCAL_LOG_DIR/${node}_load_${table}.log &
done
