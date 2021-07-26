#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "tmux"
echo_info "Installing tmux plugin manager called tpm..."
run_verbosely rm -rf ~/.tmux/plugins/tpm
run_verbosely git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
