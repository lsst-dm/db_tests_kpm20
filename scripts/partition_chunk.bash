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
# Change output dir to shared storage.
#outdir="${datadir}/partitioned/${chunk}"
outdir="${SHARED_DATA_DIR}/partitioned/${chunk}"

cmd_obj="sph-partition --verbose -c ${confdir}/Object.cfg --out.dir=${outdir}/Object --in=${indir}/Object_${chunk}.txt"

cmd_src="sph-partition --verbose -c ${confdir}/common.cfg -c ${confdir}/Source.cfg --out.dir=${outdir}/Source --in=${indir}/Source_${chunk}.txt"

cmd_fsrc="sph-partition --verbose -c ${confdir}/common.cfg -c ${confdir}/ForcedSource.cfg --out.dir=${outdir}/ForcedSource --in=${indir}/ForcedSource_${chunk}.txt"


rm  -rvf ${outdir}
mkdir -p ${outdir}
mkdir -p ${outdir}/Object
mkdir -p ${outdir}/Source
mkdir -p ${outdir}/ForcedSource

on_error() {
    echo "Cleaning up: '${outdir}'"
    rm -rvf "${outdir}/Object"
    exit 1
}

echo "Partitioning Object chunk: ${chunk}  ${cmd_obj}"
trap on_error 0
${cmd_obj}

echo "Partitioning Source chunk: ${chunk}  ${cmd_src}"
${cmd_src}

echo "Partitioning ForcedSource chunk: ${chunk}  ${cmd_fsrc}"
${cmd_fsrc}

trap - 0

## Comment these out for now.
#mv ${indir}/Source_${chunk}.txt ${outdir}/Source/chunk_${chunk}.txt
#cp ${outdir}/Object/chunk_index.bin ${outdir}/Source/

#mv ${indir}/ForcedSource_${chunk}.txt ${outdir}/ForcedSource/chunk_${chunk}.txt
#cp ${outdir}/Object/chunk_index.bin ${outdir}/ForcedSource/

echo "Partitioning Cleaning up: ${chunk} ${indir}"
rm -rvf "${indir}"
