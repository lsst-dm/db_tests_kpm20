#!/bin/bash
#
# NOTE: This script is meant to be run on the development node ccqservbuild

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

for node in $WORKERS; do
    ssh -n $node $SCRIPTS/ddp_source.bash >& $QSERV_LOCAL_LOG_DIR/${node}_ddp_source.log &
done
