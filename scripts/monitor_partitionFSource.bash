#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash


echo Incomplete: `grep -L  "Partitioning Cleaning up" ${SHARED_DATA_DIR}/log/partition_ForcedSource*`





