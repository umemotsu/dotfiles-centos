#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "git"
echo_info "Adding diff-highlight to PATH..."
run_verbosely ln -s $(brew --prefix)/share/git-core/contrib/diff-highlight/diff-highlight $(brew --prefix)/bin/
