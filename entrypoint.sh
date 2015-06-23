#!/bin/bash
set -e

. /build/reload-code.sh

# If /home/app/env.sh exists, run it!
if [ -f /home/app/app/env.sh ]
  then
    echo "Running env.sh"
    . /home/app/app/env.sh
fi

exec "$@"
