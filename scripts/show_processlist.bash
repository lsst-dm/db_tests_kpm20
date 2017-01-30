#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

${mysql_cmd} -e 'SHOW PROCESSLIST' | wc -l

