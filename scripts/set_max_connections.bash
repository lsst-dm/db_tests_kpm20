#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

${mysql_cmd} -e "SHOW VARIABLES LIKE 'max_connections'"
${mysql_cmd} -e "SET GLOBAL max_connections=8192"
${mysql_cmd} -e "SHOW VARIABLES LIKE 'max_connections'"
