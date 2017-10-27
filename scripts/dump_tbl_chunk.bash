#!/bin/bash
#
# Make a MySQL dump of the specified chunk at the default
# or explicitly specified location.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_base_stack.bash

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk> [<datadir>]"
    exit 1
fi
datadir=$QSERV_DATA_DIR
table="$2"
outdir="${datadir}/dumped/${chunk}"

rm    -rvf ${outdir}
mkdir   -p ${outdir}
chmod 0777 ${outdir}

on_error() {
    echo "Cleaning up: ${outdir}"
    rm -rvf "${outdir}"
    exit 1
}

trap on_error 0
#for table in Object Source ForcedSource; do
table_chunk="${table}_${chunk}"
echo "Dumping: ${mysqldump_cmd} ${INPUT_DB} ${table_chunk} -T${outdir}"
${mysqldump_cmd} ${INPUT_DB} ${table_chunk} -T${outdir}
trap - 0
