#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

cd ${QSERV_DATA_DIR}/chunks
for chunks in `ls -1 chunks_*`;
do
    echo "Loading group of chunks: ${chunks} (async)"
    ${SCRIPTS}/load_source_chunks.bash ${chunks} >& ${QSERV_DATA_DIR}/log/load_source_chunks.${chunks}.log&
done

