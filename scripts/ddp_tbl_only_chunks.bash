#!/bin/bash
#
# Process sequentially a sub-series of chunks on the local worker node.
# The processing has 3 stages:
#
# - making a backup of a chunk's table from the input database
# - duplicate the data
# - partition the duplicated data

set -e

chunks="$1"
table="$2"
option="$3"

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

for chunk in `cat ${QSERV_DATA_DIR}/chunks/${chunks}`; do
    echo "Processing chunk: ${chunk} ${table} ${option}"
    $SCRIPTS/dump_tbl_chunk.bash      $chunk $table >& $QSERV_DATA_DIR/log/dump_${table}.${chunk}.log
    $SCRIPTS/duplicate_tbl_chunk.bash $chunk $option >& $QSERV_DATA_DIR/log/duplicate_${table}.${chunk}.log
    $SCRIPTS/partition_tbl_chunk.bash $chunk $table >& $SHARED_DATA_DIR/log/partition_${table}.${HOSTNAME}.${chunk}.log
done

