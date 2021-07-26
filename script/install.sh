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

echo
echo_info "-------"
echo_info "WRAP-UP"
echo_info "-------"
echo_info "Installation has been completed."
echo
echo_info "Next steps:"
echo_info "- Run \`exec \${SHELL} -l\` to enable the installed features immediately. (Alternatively, logout and login again.)"
echo_info "- Run \`chsh\` command to change login shell to zsh."
echo_info "- Run \`tmux\` command and then press \`Ctrl-z + I\` to install plugins."
