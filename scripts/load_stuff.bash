#!/bin/bash

set -e

SCRIPT=`readlink -f $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

sourceDir="$1"
table="$2"

cd $sourceDir

for subDir in `ls -1 load*`; do
    echo "subDir: $subDir"
    cmd="${SCRIPTS}/load_stuff_sub.bash ${sourceDir}/${subDir} ${table}"
    echo $cmd
    $cmd >& $QSERV_DATA_DIR/log/load_stuff.${sourceDir}_${subDir}.log&
done


