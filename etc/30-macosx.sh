#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "macosx"
echo_warning "Do nothing as this script is under development."
# FYI:
# - https://github.com/holman/dotfiles/blob/master/macos/set-defaults.sh
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://github.com/lra/mackup/blob/master/mackup/applications/macosx.cfg
# - https://github.com/ikuwow/dotfiles/blob/master/scripts/configure.sh
