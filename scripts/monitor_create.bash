#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

echo
echo "  Checking loading dirs"
echo



for node in $WORKERS; do
    ssh -n $node "echo \`hostname\` \`${SCRIPTS}/check_create.bash \`"
done

