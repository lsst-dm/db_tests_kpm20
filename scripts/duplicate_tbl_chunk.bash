#!/bin/bash

set -e

# The -j option controls the number of duplicate made, see sph-duplicate2
# ex: -j 2     This copies the original Object table and makes 2 duplicates,
#              effectively tripling the size of the table.
#
# The Source and ForcedSource duplication make use of the .map file 
# created by sph-duplicate2 when duplicating the Object tables. It makes
# duplicates of rows to match what is in the map. Three Object row
# copies results in 3 Source row copies.
#

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_partition_stack.bash

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk> [<datadir>]"
    exit 1
fi

datadir=$QSERV_DATA_DIR
tableopt="$2"

coldefdir="${SCRIPTS}/../coldef"
indir="${datadir}/dumped/${chunk}"
outdir="${datadir}/duplicated/${chunk}"

htm_level=9
ra_shift=0.1
cmd_coldef_opt="-O ${coldefdir}/Object.coldef -S ${coldefdir}/Source.coldef -F ${coldefdir}/ForcedSource.coldef"
cmd_opts="${cmd_coldef_opt} -l ${htm_level} -i ${indir} -o ${outdir} -t ${ra_shift} -D -j 2 -N ${chunk}" 
#cmd_obj="sph-duplicate2 -v --dup.object ${cmd_opts}"
#cmd_src="sph-duplicate2 -v --dup.source ${cmd_opts}"
#cmd_fsrc="sph-duplicate2 -v --dup.forcedsource ${cmd_opts}"

cmd_tbl="sph-duplicate2 -v ${tableopt} ${cmd_opts}"




rm  -rvf ${outdir}/*.txt
mkdir -p ${outdir}

on_error() {
    echo "Cleaning up: ${outdir}"
    rm -rvf "${outdir}"
    exit 1
}
trap on_error 0

echo "Duplicating table chunk: ${chunk}  ${cmd_tbl}"
${cmd_tbl}

trap - 0
echo "Cleaning up: ${indir}"
rm -rvf "${indir}"
