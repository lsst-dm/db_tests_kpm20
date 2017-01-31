#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

worker=`hostname`

get_table_names_sql="SELECT CONCAT(TABLE_SCHEMA,'.',TABLE_NAME) FROM information_schema.tables WHERE TABLE_SCHEMA='${OUTPUT_DB}' AND TABLE_NAME LIKE 'Object%'"
for database_table in `${mysql_cmd} -e "${get_table_names_sql}"`;
do
  echo "${worker}: ${database_table}"
  ${mysql_cmd} -e "DROP TABLE ${database_table}"
done
