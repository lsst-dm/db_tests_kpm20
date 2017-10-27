#!/bin/bash
#
# NOTE: This script is meant to be run on the development node ccqservbuild

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash


python partitioned_obj_chunk_count.py 101 124 ${SHARED_DATA_DIR}/partitionedObjAll


#for node in $WORKERS; do
#    ssh -n $node $SCRIPTS/create_directories.bash >& $QSERV_LOCAL_LOG_DIR/${node}_create_directories.log &
#done
