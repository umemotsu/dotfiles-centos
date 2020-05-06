#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "Creating symlinks to dot files..."
cd "${DOT_ROOT}/dot"
for dot_file in *; do
    ln -fvns "$(pwd)/${dot_file}" "${HOME}/.${dot_file}"
done

echo
echo_info "Creating symlinks to executable files..."
mkdir -p "${HOME}/bin"
cd "${DOT_ROOT}/bin"
for bin_file in *; do
    if [ ! -f "${bin_file}" ]; then
        echo_warning "Ignore non-regular file (${bin_file})."
        continue
    fi
    if [ ! -x "${bin_file}" ]; then
        echo_warning "Ignore non-executable file (${bin_file})."
        continue
    fi
    ln -fvns "$(pwd)/${bin_file}" "${HOME}/bin/${bin_file}"
done
