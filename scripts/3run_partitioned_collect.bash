#!/bin/bash
#
# NOTE: This script is meant to be run on the development node ccqservbuild

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

table="Object"

for node in $WORKERS; do
    ssh -n $node python $SCRIPTS/partitioned_obj_chunk_count.py collect ${SHARED_DATA_DIR}/partitioned ${QSERV_DATA_DIR}/loadingi${table} >& $QSERV_LOCAL_LOG_DIR/collect.log &
done
