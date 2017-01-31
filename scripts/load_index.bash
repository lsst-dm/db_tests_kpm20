#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

mkdir -p $QSERV_DATA_DIR/dumps/log

cd $QSERV_DATA_DIR/dumps
for f in `ls -1 *.tsv`; do
  echo "Loading: ${f}";
  $mysql_cmd -e "LOAD DATA INFILE '/qserv/data/kpm20/dumps/${f}' INTO TABLE qservMeta.${OUTPUT_DB}__Object" >& log/load_${f}.log
done
