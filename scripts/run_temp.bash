#!/bin/bash
#

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`


source $SCRIPTS/env_base_stack.bash

for node in $WORKERS; do
    ssh -n $node $SCRIPTS/temp.bash 
done
