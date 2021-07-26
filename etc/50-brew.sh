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

    echo_info "Export brew-specific variables"
    if [ "$(uname -m)" = "arm64" ]; then
        eval $(/opt/homebrew/bin/brew shellenv)
    else
        eval $(/usr/local/bin/brew shellenv)
    fi

    echo_info "Checking if any potential problems exist..."
    run_verbosely brew doctor
fi

echo_info "Installing packages in Brewfile..."
cd "${DOT_ROOT}"
run_verbosely brew bundle install --verbose
