#!/bin/bash
#
# quick script to be modified for running one time commands.
###load_prep.bash ${QSERV_DATA_DIR}/partitioned

set -e

hname=`hostname`

SCRIPT=`readlink -f $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash


echo $PWD
cd ${QSERV_DATA_DIR}/loadingSource
echo ${hname} zipped `ls -1 *.gz | wc -l`
echo ${hname} txt `ls -1 *.txt | wc -l`
#mkdir ${SHARED_DATA_DIR}/${hname}
#cp -r loadingObject ${SHARED_DATA_DIR}/${hname}/.
#rm -r loadingObject


