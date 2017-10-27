#!/bin/bash

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

coldefdir="${SCRIPTS}/../coldef"
indir="${datadir}/dumped/${chunk}"
outdir="${datadir}/duplicated/${chunk}"

htm_level=9
ra_shift=0.1
cmd_coldef_opt="-O ${coldefdir}/Object.coldef -S ${coldefdir}/Source.coldef -F ${coldefdir}/ForcedSource.coldef"
cmd_opts="${cmd_coldef_opt} -l ${htm_level} -i ${indir} -o ${outdir} -t ${ra_shift} -D -j 2 -N ${chunk}" 
cmd_obj="sph-duplicate2 -v --dup.object ${cmd_opts}"
cmd_src="sph-duplicate2 -v --dup.source ${cmd_opts}"
cmd_fsrc="sph-duplicate2 -v --dup.forcedsource ${cmd_opts}"



rm  -rvf ${outdir}
mkdir -p ${outdir}

on_error() {
    echo "Cleaning up: '${outdir}'"
    rm -rvf "${outdir}"
    exit 1
}
trap on_error 0

echo "Duplicating Object chunk: ${chunk}  ${cmd_obj}"
${cmd_obj}

echo "Duplicating Source chunk: ${chunk}  ${cmd_src}"
${cmd_src}

echo "Duplicating ForcedSource chunk: ${chunk}  ${cmd_fsrc}"
${cmd_fsrc}


trap - 0
echo "Cleaning up: '${indir}'"
rm -rvf "${indir}"
