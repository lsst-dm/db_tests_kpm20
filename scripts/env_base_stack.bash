#! /bin/bash
#
# ATTENTION: this script is always 'sourced', and it requires that
#            the environment variable 'SCRIPTS' pointing to a location
#            of this and other scripts was set up prior to source
#            this one.

if [ -z "${SCRIPTS}" ]; then
  echo "env_base_stack.bash: incorrect use of the script without"
  echo "    a proper setting of environment variable SCRIPTS."
  echo "    The script was called from: $0"
  if [ "$0" ne "-bash" ]; then
    exit 1
  fi
else
  source $SCRIPTS/env.bash
  source $BASE_STACK/loadLSST.bash
  setup -t qserv-dev qserv_distrib
fi
