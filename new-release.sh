#!/usr/bin/env bash
# ./new-release.sh elasticsearch-version search-guard-version ear-version
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e

"$SCRIPT_DIR/sgconfig.py" new-release  --esv "$1" --sgv "$2" --ear-sgv "$2"