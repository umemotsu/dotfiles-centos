#!/bin/bash

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
    [ ! -f "${bin_file}" ] && continue
    [ ! -x "${bin_file}" ] && continue
    ln -fvns "$(pwd)/${bin_file}" "${HOME}/bin/${bin_file}"
done
