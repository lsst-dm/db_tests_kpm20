#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

echo
echo "  Checking loading dirs"
echo



for node in $WORKERS; do
    echo "--------------------------------------"
    ssh -n $node "echo \`hostname\` ERRORS: \`grep -i "error" ${QSERV_DATA_DIR}/log/load_stuff.Source_load* \`"
    ssh -n $node "echo \`hostname\` complete: \`grep "loaded chunks" ${QSERV_DATA_DIR}/log/load_stuff.Source_load* | wc -l \`"
done

