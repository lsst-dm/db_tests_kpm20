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

for d in ${QSERV_DATA_DIR}/log $QSERV_DUMPS_DIR ${QSERV_DATA_DIR}/dumped; do
  cmd="rm -rf ${d}/*"
  echo $cmd
  $cmd
done

for d in `ls -1 ${QSERV_DATA_DIR}/duplicated`; do
  dr="${QSERV_DATA_DIR}/duplicated/${d}"
  cmd="rm -rf ${dr}/*.txt"
  #cmd="rm -rf ${dr}"
  echo $cmd
  $cmd
done
