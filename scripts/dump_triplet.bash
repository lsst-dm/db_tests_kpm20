#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

cd $QSERV_DATA_DIR/chunks
for chunks in `ls -1 chunks_*`; do
    echo "Dumping triplets of chunks: ${chunks} (async)"
    $SCRIPTS/dump_triplet_chunks.bash $chunks >& $QSERV_DATA_DIR/log/dump_triplet_chunks.${chunks}.log&
done

