#!/bin/bash
#
# Create or recreate the output database on a local database server
# of a worker node.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

$mysql_cmd -e "DROP DATABASE IF EXISTS ${OUTPUT_DB};"
$mysql_cmd -e "CREATE DATABASE IF NOT EXISTS ${OUTPUT_DB};"
$mysql_cmd -e "GRANT ALL ON ${OUTPUT_DB}.* TO 'qsmaster'@'localhost';"
$mysql_cmd -e "FLUSH PRIVILEGES;"
