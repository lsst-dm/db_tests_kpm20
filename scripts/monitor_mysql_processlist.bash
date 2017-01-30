#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`
source $SCRIPTS/env.bash

echo
echo "  Monitoring: DATABASE CONNECTIONS"
echo

echo "      worker | total "
echo " ------------+-------"

for node in ${MASTER} ${WORKERS}
do
  ssh -n ${node} 'echo "  "`hostname`" | "`'${SCRIPTS}'/show_processlist.bash`'
done

echo
