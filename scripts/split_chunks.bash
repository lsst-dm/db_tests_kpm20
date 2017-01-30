#!/bin/bash
#
# Split a sequence of a worker node's chunk numbers into a sub-series
# for further use by parallel processing tools.
#
# NOTE: This script is meant to be run on a worker node

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

CHUNKS_DIR="$QSERV_DATA_DIR/chunk"

rm    -rf $CHUNKS_DIR
mkdir -p  $CHUNKS_DIR
cd        $CHUNKS_DIR

cat ../chunks.txt | split -l 36 -d - chunks_
