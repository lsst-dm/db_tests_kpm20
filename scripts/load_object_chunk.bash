#!/bin/bash

set -e

chunk="$1"
if [ -z "${chunk}" ]; then
    echo "usage: <chunk>"
    exit 1
fi

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

source $SCRIPTS/env_qserv_stack.bash

worker=`/usr/bin/hostname`

config_dir="${SCRIPTS}/../config"
data_dir="${QSERV_DATA_DIR}/partitioned/${chunk}/Object"
object2worker_dir="${QSERV_DATA_DIR}/partitioned/${chunk}/Object_to_Worker"
chunk2worker="${SCRIPTS}/../chunk2worker"

worker=`/usr/bin/hostname`

loader=`which qserv-data-loader.py`

opt_verbose="--verbose --verbose --verbose --verbose-all"
opt_conn="--host=${MASTER} --port=5012 --secret=${config_dir}/wmgr.secret --no-css"
opt_config="--config=${config_dir}/common.cfg --config=${config_dir}/Object.cfg"
opt_db_table_schema="${OUTPUT_DB} Object ${config_dir}/Object.sql"

echo "----------------------------------------------------------------------------------------"
echo "["`date`"] ** Begin loading chunk ${chunk} at worker: ${worker} **"
echo "----------------------------------------------------------------------------------------"

rm -rf "${object2worker_dir}"
mkdir -p "${object2worker_dir}"
mkdir -p "${object2worker_dir}/${worker}"
ln -s "${data_dir}/chunk_${chunk}.txt" "${object2worker_dir}/${worker}/"
cp -f "${data_dir}/chunk_index.bin"    "${object2worker_dir}/${worker}/"

for f in `ls "${data_dir}" | grep "overlap.txt"`; do
  chunk_overlap=${f:6:-12}
  chunk2worker_map="${chunk2worker}/${chunk_overlap}"
  if [ -f "${chunk2worker_map}" ]; then
    chunk_worker=`cat ${chunk2worker_map}`
    mkdir -p "${object2worker_dir}/${chunk_worker}"
    ln -s "${data_dir}/${f}"            "${object2worker_dir}/${chunk_worker}/"
    cp -f "${data_dir}/chunk_index.bin" "${object2worker_dir}/${chunk_worker}/"
  fi
done

for chunk_worker in `ls "${object2worker_dir}"`; do

  echo "["`date`"] ** Begin loading data to worker: ${chunk_worker} **"
  echo "----------------------------------------------------------------------------------------"

  opt_data="--index-db= --skip-partition --chunks-dir=${object2worker_dir}/${chunk_worker}"
  loadercmd="${loader} ${opt_verbose} ${opt_conn} --worker=${chunk_worker} ${opt_config} ${opt_data} ${opt_db_table_schema}"

  echo ${loadercmd}
  $loadercmd

  echo "----------------------------------------------------------------------------------------"
  echo "["`date`"] ** Finished loading data to worker: ${chunk_worker} **"
  echo "----------------------------------------------------------------------------------------"

done

echo "["`date`"] ** Finished loading chunk ${chunk} at worker: ${worker} **"

