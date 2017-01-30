#!/bin/bash
#
# Partition the specified chunk and store results at the default or
# explicitly specified folder.

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_partition_stack.bash

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk> [<datadir>]"
    exit 1
fi
datadir="$2"
if [ -z "${datadir}" ]; then

    # Assuming the default destination as per the current
    # configuration of the processing pipeline.

    datadir=$QSERV_DATA_DIR
fi

confdir="${SCRIPTS}/../config"
indir="${datadir}/duplicated/${chunk}"
outdir="${datadir}/partitioned/${chunk}"

cmd="sph-partition --verbose -c ${confdir}/Object.cfg --out.dir=${outdir}/Object --in=${indir}/Object_${chunk}.txt"

rm  -rvf ${outdir}
mkdir -p ${outdir}
mkdir -p ${outdir}/Object
mkdir -p ${outdir}/Source
mkdir -p ${outdir}/ForcedSource

on_error() {
    echo "Cleaning up: '${outdir}'"
    rm -rvf "${outdir}"
    exit 1
}

echo "Partitioning chunk: ${chunk}"
trap on_error 0
${cmd}
trap - 0

mv ${indir}/Source_${chunk}.txt ${outdir}/Source/chunk_${chunk}.txt
cp ${outdir}/Object/chunk_index.bin ${outdir}/Source/

mv ${indir}/ForcedSource_${chunk}.txt ${outdir}/ForcedSource/chunk_${chunk}.txt
cp ${outdir}/Object/chunk_index.bin ${outdir}/ForcedSource/

echo "Cleaning up: ${indir}"
rm -rvf "${indir}"
