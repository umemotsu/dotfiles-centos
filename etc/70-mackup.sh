#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "mackup"
echo_info "Restoring application settings synced by mackup..."
run_verbosely mackup --verbose restore
