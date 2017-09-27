#!/bin/bash
#
# Extract chunk numbers associated with the current  worker node
# from the input database, sort them (DESC) numerically and print
# them to the standard output.
#
# NOTE: This script is meant to be run on a worker node

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

for d in $QSERV_DATA_DIR $QSERV_DUMPS_DIR; do
  sudo -u qserv mkdir -p $d
  sudo -u qserv chmod 0777 $d
done
