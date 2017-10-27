#!/bin/bash
#
# The driver script for initiating the first three stages of
# processing all chunks associated with the local worker node.
# Subseries of chunks will be processed asynchriously.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

table="$1"
option="$2"

cd $QSERV_DATA_DIR/chunks
for chunks in `ls -1 chunks_*`; do
    echo "Processing Object only chunk: ${chunks} ${table} ${option} (async)"
    nohup ${SCRIPTS}/ddp_tbl_only_chunks.bash ${chunks} ${table} ${option} \
      >& ${SHARED_DATA_DIR}/log/ddp_tbl_only_chunks.${HOSTNAME}.${table}.${chunks}.log&
done

