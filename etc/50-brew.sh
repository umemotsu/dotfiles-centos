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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo_info "Export brew-specific variables"
    source "${DOT_ROOT}/dot/bash/inits/50-brew.sh"

    echo_info "Adding brew repositories..."
    run_verbosely brew tap "homebrew/core"
    run_verbosely brew tap "homebrew/bundle"

    echo_info "Checking if any potential problems exist..."
    run_verbosely brew doctor || {
        echo_warning "Found some potential problem(s)."
        read -n 1 -p "Do you want to continue installation? [y/n]: " yn
        echo
        if [[ ! ${yn} =~ ^[Yy]$ ]]; then
            exit 1
        fi
    }
fi

echo_info "Installing packages in Brewfile..."
cd "${DOT_ROOT}"
run_verbosely brew bundle install --verbose
