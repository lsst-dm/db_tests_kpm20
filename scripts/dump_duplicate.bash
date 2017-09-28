#!/bin/bash
#
# The driver script for initiating the first two  stages of
# processing all chunks associated with the local worker node.
# Subseries of chunks will be processed asynchriously.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

cd $QSERV_DATA_DIR/chunks
for chunks in `ls -1 chunks_*`; do
    echo "Processing chunk: ${chunks} (async)"
    nohup ${SCRIPTS}/dump_duplicate_chunks.bash ${chunks} \
      >& ${QSERV_DATA_DIR}/log/dump_duplicate_chunks.${chunks}.log&
done

