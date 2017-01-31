#!/bin/bash

set -e

verbose='false'
if [ "$1" == "-v" ]; then
  verbose="true"
fi

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

partitions=''

for c in `cat ${QSERV_DATA_DIR}/chunks.txt`; do
  chunks=0
  for f in `ls ${QSERV_DATA_DIR}/partitioned/${c}/Object/*.txt`; do
    [[ ${f} =~ _overlap.txt$ ]] || let "chunks=chunks+1"
  done
  if [ "${chunks}" -gt "1" ]; then
     echo $c
     partitions="${partitions} ${c}"
  fi
done

if [ "${partitions}" != '' ]; then
  if [ "${verbose}" == "true" ]; then
    source $SCRIPTS/env_partition_stack.bash
    sph-layout $partitions
  fi
fi
