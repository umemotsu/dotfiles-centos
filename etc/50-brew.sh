#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "brew"

if type brew >/dev/null 2>&1; then
    echo_warning "Skip brew installation as it already exists."
else
    echo_info "Installing brew itself..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew doctor
fi

echo_info "Installing packages in Brewfile..."
cd "${DOT_ROOT}"
brew bundle install --verbose
