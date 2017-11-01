#!/bin/bash

set -e

SCRIPT=`readlink -f $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

sourceDir="$1"
cd $sourceDir

for subDir in `ls -1 load*`; do
    echo "subDir: $subDir"
    cmd="${SCRIPTS}/load_stuff_sub.bash ${sourceDir}/${subDir}"
    echo $cmd
    $cmd >& $QSERV_DATA_DIR/log/load_object_chunks.${chunks}.log&
done



#cd $QSERV_DATA_DIR/chunks
#for chunks in `ls -1 chunks_*`; do
#    echo "Loading group of chunks: ${chunks} (async)"
#    $SCRIPTS/load_object_chunks.bash $chunks >& $QSERV_DATA_DIR/log/load_object_chunks.${chunks}.log&
#done
