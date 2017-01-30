#!/bin/bash

set -e

chunks="$1"

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

for chunk in `cat ${QSERV_DATA_DIR}/chunks/${chunks}`;
do
    echo "Dumping triplets of chunk: ${chunk}"
    ${SCRIPTS}/dump_triplet_chunk.bash ${chunk} >& ${QSERV_DATA_DIR}/log/dump_triplet.${chunk}.log
done

