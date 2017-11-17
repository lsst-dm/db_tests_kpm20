#!/bin/bash
#
# Count all the *_chunk_*.txt files
# 4 subdirectories in the sourceDir with names load1,load2, ..., load8
# Divide up the Source files among the load# directories using soft links
# for later programs to load in parallel

###load_prep.bash ${QSERV_DATA_DIR}/partitioned

set -e

sourceDir="$1"

SCRIPT=`readlink -f $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

cd $sourceDir
echo $PWD

# get rid of any load# directory
for ((val=0;val<=9;val++)); do
    cmdRm="rm -rf load${val}"
    echo "cmdRm: $cmdRm"
    $cmdRm
done


dirCount=3
for ((val=1;val<=dirCount;val++)); do
    dirName="load${val}"
    cmdDir="mkdir -p load${val}"
    echo "cmdDir: $cmdDir"
    $cmdDir
    cmdRm="rm -rf load${val}/*"
    echo "cmdRm: $cmdRm"
    $cmdRm
    cmdT="touch load${val}/chunk_index.bin"
    echo "cmdT: $cmdT"
    $cmdT
done

count=`ls -1 *_chunk_* | wc -l`
echo "count $count"
#val=1
#for chFile in `ls -1 *_chunk_*`; do
#    destName="load${val}"
#    wholePath="${sourceDir}/${chFile}"
#    cmdLn="ln -s $wholePath ${destName}/$chFile"
#    echo "linking $cmdLn"
#    $cmdLn
#
#    val=$((val+1))
#    if [ $val -gt $dirCount ]; then
#        val=1
#    fi
#done

# Try to group the files so that it is less likely 
# to have two loaders trying to work on the same table.
max_fcount=500
fcount=0
val=1
for chFile in `ls -1 *_chunk_*`; do
    destName="load${val}"
    wholePath="${sourceDir}/${chFile}"
    cmdLn="ln -s $wholePath ${destName}/$chFile"
    echo "linking $cmdLn"
    $cmdLn

    fcount=$((fcount+1))
    if [ $fcount -gt $max_fcount ]; then
        fcount=0
        val=$((val+1))
        if [ $val -gt $dirCount ]; then
            val=1
        fi
    fi
done

