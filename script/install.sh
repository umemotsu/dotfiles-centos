#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "----------"
echo_info "DEPLOYMENT"
echo_info "----------"
run_verbosely "${DOT_ROOT}/script/deploy.sh"

echo
echo_info "--------------"
echo_info "INITIALIZATION"
echo_info "--------------"
run_verbosely "${DOT_ROOT}/script/initialize.sh"
