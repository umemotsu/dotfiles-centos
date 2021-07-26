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
    if [ -d ~/.linuxbrew ]; then
        eval $(~/.linuxbrew/bin/brew shellenv)
    elif [ -d /home/linuxbrew/.linuxbrew ]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    else
        echo_error "Failed to locate brew prefix path."
        exit 1
    fi

    echo_info "Adding brew repositories..."
    run_verbosely brew tap "homebrew/core"
    run_verbosely brew tap "homebrew/bundle"

    echo_info "Checking if any potential problems exist..."
    run_verbosely brew doctor
fi

echo_info "Installing packages in Brewfile..."
cd "${DOT_ROOT}"
run_verbosely brew bundle install --verbose
