#!/bin/bash

set -e

SCRIPT=`realpath $0`
SCRIPTS=`dirname $SCRIPT`

ps -ef | grep gapon | grep "${SCRIPTS}/load_object_chunks" | grep .bash
kill -9 `(ps -ef | grep gapon | grep "${SCRIPTS}/load_object_chunks" | grep .bash | awk '{print $2}')`
