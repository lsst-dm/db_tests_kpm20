#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

echo
echo "  Monitoring: DUMP DUPLICATE PARTITION"
echo

echo "      worker | total | dump | dupl | part "
echo " ------------+-------+------+------+------"

for node in $WORKERS; do
  ssh -n $node "echo '  '\`hostname\` \| \"\`cat ${QSERV_DATA_DIR}/chunks.txt | wc -l | awk '{printf \" %3d \", \$0}'\`\" \| \"\`ls -1 ${QSERV_DATA_DIR}/dumped | wc -l | awk '{printf \"%4d\", \$0}' \`\" \| \"\`ls -1 ${QSERV_DATA_DIR}/duplicated | wc -l | awk '{printf \"%4d\", \$1}' \`\" \| \"\`ls -1 ${QSERV_DATA_DIR}/partitioned | wc -l | awk '{printf \"%4d\", \$0}' \`\""
done

echo
