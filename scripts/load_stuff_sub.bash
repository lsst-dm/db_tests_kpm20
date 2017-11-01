#!/bin/bash
#
#
#
### load_stuff_sub.bash /afs/slac.stanford.edu/u/sf/jgates/loading/load2


set -e

sourceDir="$1"
table="$2"

SCRIPT=`readlink -f $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env.bash

loader=`which qserv-data-loader.py`

config_dir="${SCRIPTS}/../config"


opt_verbose="--verbose --verbose --verbose --verbose-all"
opt_conn="--host=${MASTER} --port=5012 --secret=${config_dir}/wmgr.secret --no-css"
opt_config="--config=${config_dir}/common.cfg --config=${config_dir}/${table}.cfg"
opt_db_table_schema="${OUTPUT_DB} ${table} ${config_dir}/${table}.sql"

opt_data="--index-db= --skip-partition --chunks-dir=${sourceDir}"

loadercmd="${loader} ${opt_verbose} ${opt_conn} --worker=${chunk_worker} ${opt_config} ${opt_data} ${opt_db_table_schema}"

echo "cmd: $loadercmd"
$loadercmd


