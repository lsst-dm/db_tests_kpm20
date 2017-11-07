#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

#source $SCRIPTS/env.bash
source $SCRIPTS/env_base_stack.bash

echo `hostname` DATABASE:`${mysql_cmd} -e "SHOW DATABASES" | grep "${OUTPUT_DB}" `

