#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

echo
echo "  Monitoring: LOAD 'FORCED' SOURCE"
echo

echo "      worker | total | begin | finish | in-progress "
echo " ------------+-------+-------+--------+-------------"

for node in $WORKERS; do

  in_progress=`ssh -n ${node} 'ps -ef | grep gapon | grep load_forcedsource_chunk.bash | wc -l'`
  in_progress=$((in_progress - 2))
  in_progress=`echo ${in_progress} | awk '{printf "%11d", $0}'`

  ssh -n $node "echo '  '\`hostname\` \| \"\`cat ${QSERV_DATA_DIR}/chunks.txt | wc -l | awk '{printf \" %3d \", \$0}'\`\" \| \"\`fgrep Begin ${QSERV_DATA_DIR}/log/load_forcedsource.*.log | wc -l | awk '{printf \"%5d\", \$0}' \`\" \| \"\`fgrep Finished ${QSERV_DATA_DIR}/log/load_forcedsource.*.log | wc -l | awk '{printf \"%6d\", \$1}' \`\" \| ${in_progress}"
done

echo
