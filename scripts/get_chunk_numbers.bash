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

cd $QSERV_DATA_DIR

echo "\
SELECT SUBSTR(TABLE_NAME,8) \
  FROM information_schema.tables \
  WHERE TABLE_SCHEMA='${INPUT_DB}' \
  AND TABLE_NAME LIKE 'Object\_%' AND TABLE_ROWS > 0;" | $mysql_cmd | sort -n \
> chunks.txt

rm -rf chunks
mkdir  chunks
cd     chunks
cat ../chunks.txt | split -l 90 -d - chunks_
