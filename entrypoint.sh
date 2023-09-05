#!/bin/bash
set -e

. /build/reload-code.sh

exec "$@"
