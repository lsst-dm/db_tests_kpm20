#!/bin/bash
#
# The driver script for initiating the first three stages of
# processing all chunks associated with the local worker node.
# Subseries of chunks will be processed asynchriously.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

cd $QSERV_DATA_DIR/chunks
for chunks in `ls -1 chunks_*`; do
    echo "Processing Source chunk: ${chunks} (async)"
    nohup ${SCRIPTS}/ddp_source_chunks.bash ${chunks} \
      >& ${SHARED_DATA_DIR}/log/ddp_source_chunks.${HOSTNAME}.${chunks}.log&
done

