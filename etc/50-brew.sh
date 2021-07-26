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
    run_verbosely git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
    run_verbosely mkdir ~/.linuxbrew/bin
    run_verbosely ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin

    echo_info "Export brew-specific variables"
    eval $(~/.linuxbrew/bin/brew shellenv)

    echo_info "Adding brew repositories..."
    run_verbosely brew tap "homebrew/core"
    run_verbosely brew tap "homebrew/bundle"

    echo_info "Checking if any potential problems exist..."
    run_verbosely brew doctor
fi

echo_info "Installing packages in Brewfile..."
cd "${DOT_ROOT}"
run_verbosely brew bundle install --verbose
