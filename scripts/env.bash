#! /bin/bash

# Custom versions of the LSST Stack and two packages used
# by the scripts.

BASE_STACK='/sps/lsst/data/gapon/stack'
PARTITION_PKG='/sps/lsst/data/gapon/development/partition'
QSERV_PKG='/sps/lsst/data/gapon/development/qserv'

# Qserv deployment parameters (adjust accordingly)

MYSQL_PASSWORD='changeme'

MASTER='ccqserv125'
WORKERS=`seq --format 'ccqserv%3.0f' 126 149`

QSERV_DATA_DIR='/qserv/data/kpm20'
QSERV_MYSQL_DIR='/qserv/data/mysql'
QSERV_DUMPS_DIR='/qserv/data/dumps'
QSERV_LOCAL_LOG_DIR='/tmp/kpm20/log'

# Source and destination databases

INPUT_DB='LSST'
OUTPUT_DB='LSST20'

# Shortcuts

mysql_cmd="mysql -B -N -A -S ${QSERV_MYSQL_DIR}/mysql.sock -h localhost -P13306 -uroot -p${MYSQL_PASSWORD}"
mysqldump_cmd="mysqldump  -S ${QSERV_MYSQL_DIR}/mysql.sock -h localhost -P13306 -uroot -p${MYSQL_PASSWORD}"


