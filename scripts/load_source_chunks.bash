#!/bin/bash

set -e

chunks="$1"

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

for chunk in `cat ${QSERV_DATA_DIR}/chunks/${chunks}`;
do
    echo "Loading chunk: ${chunk}"
    ${SCRIPTS}/load_source_chunk.bash ${chunk} >& ${QSERV_DATA_DIR}/log/load_source.${chunk}.log
done
