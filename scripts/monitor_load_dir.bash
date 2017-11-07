#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

echo
echo "  Checking loading dirs"
echo


#for node in $WORKERS; do
#  ssh -n $node "echo '  '\`hostname\` \| \d \", \$0}'\`\" \| \"\`ls -1 ${QSERV_DATA_DIR}/dumped | wc -l | awk '{printf \"%4d\", \$0}' \`\" \| \"\`ls -1 ${QSERV_DATA_DIR}/duplicated | wc -l | awk '{printf \"%4d\", \$1}' \`\" \| \"\`ls -1 ${QSERV_DATA_DIR}/log/dupli* | wc -l | awk '{printf \"%4d\", \$0}' \`\""
#done

for node in $WORKERS; do
    ssh -n $node "echo \`hostname\` Obj.txt:\`ls -1 ${QSERV_DATA_DIR}/loadingObject/*.txt | wc -l \` loadObjdirs:\`ls -1d ${QSERV_DATA_DIR}/loadingObject/load* | wc -l \`   loadObj:\`ls -1 ${QSERV_DATA_DIR}/loadingObject/load*/*.txt | wc -l \`"
    ssh -n $node "echo \`hostname\` \`ls -lah ${QSERV_DATA_DIR}/log/load_stuff.Object_load*\`" 
done

