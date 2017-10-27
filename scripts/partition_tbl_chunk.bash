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
    echo "usage: <chunk> <table>"
    exit 1
fi
table="$2"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk> <table>"
    exit 1
fi

datadir=$QSERV_DATA_DIR

confdir="${SCRIPTS}/../config"
indir="${datadir}/duplicated/${chunk}"
# Change output dir to shared storage.
#outdir="${datadir}/partitioned/${chunk}"
outdir="${SHARED_DATA_DIR}/partitioned/${chunk}"

#cmd_obj="sph-partition --verbose -c ${confdir}/Object.cfg --out.dir=${outdir}/Object --in=${indir}/Object_${chunk}.txt"

#cmd_src="sph-partition --verbose -c ${confdir}/common.cfg -c ${confdir}/Source.cfg --out.dir=${outdir}/Source --in=${indir}/Source_${chunk}.txt"

#cmd_fsrc="sph-partition --verbose -c ${confdir}/common.cfg -c ${confdir}/ForcedSource.cfg --out.dir=${outdir}/ForcedSource --in=${indir}/ForcedSource_${chunk}.txt"

cmd_tbl="sph-partition --verbose -c ${confdir}/common.cfg -c ${confdir}/${table}.cfg --out.dir=${outdir}/${table} --in=${indir}/${table}_${chunk}.txt"

rm  -rvf ${outdir}/${table}
mkdir -p ${outdir}
mkdir -p ${outdir}/${table}

on_error() {
    echo "Cleaning up: '${outdir}'/'${table}'"
    rm -rvf "${outdir}/${table}"
    exit 1
}

echo "Partitioning table chunk: ${chunk}  ${cmd_tbl}"
trap on_error 0
${cmd_tbl}


trap - 0

## Comment these out for now.
#mv ${indir}/Source_${chunk}.txt ${outdir}/Source/chunk_${chunk}.txt
#cp ${outdir}/Object/chunk_index.bin ${outdir}/Source/

#mv ${indir}/ForcedSource_${chunk}.txt ${outdir}/ForcedSource/chunk_${chunk}.txt
#cp ${outdir}/Object/chunk_index.bin ${outdir}/ForcedSource/

# Do not delete the duplicator .map file.
cmd_rm="rm -f ${indir}/*.txt"
echo "Partitioning Cleaning up: ${chunk} ${cmd_rm}"
#rm -f "${indir}/*.txt"
${cmd_rm}
