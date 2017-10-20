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

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

for chunk in `cat ${QSERV_DATA_DIR}/chunks/${chunks}`; do
    echo "Processing chunk: ${chunk}"
    $SCRIPTS/dump_source_chunk.bash      $chunk >& $QSERV_DATA_DIR/log/dump_source.${chunk}.log
    $SCRIPTS/duplicate_source_chunk.bash $chunk >& $QSERV_DATA_DIR/log/duplicate_source.${chunk}.log
    $SCRIPTS/partition_chunk.bash $chunk >& $SHARED_DATA_DIR/log/partition_source.${HOSTNAME}.${chunk}.log
done

