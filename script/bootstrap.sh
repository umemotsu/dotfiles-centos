#!/bin/bash

set -eu

# Workaround for the limitation of source command with process substitution in (old?) bash
# - https://stackoverflow.com/questions/32596123/why-source-command-doesnt-work-with-process-substitution-in-bash-3-2
# - https://lists.gnu.org/archive/html/bug-bash/2006-01/msg00018.html
source /dev/stdin <<<"$(curl --silent https://raw.githubusercontent.com/umemotsu/dotfiles/master/script/utils.sh)"

DOT_ROOT="$(printenv DOT_ROOT || echo)"
if [ -z "${DOT_ROOT}" ]; then
    DOT_ROOT="${HOME}/.dotfiles"
fi

echo
echo_info "--------"
echo_info "DOWNLOAD"
echo_info "--------"
if [ -d "${DOT_ROOT}" ]; then
    echo_warning "Skip downloading as the repository already exists at \"${DOT_ROOT}\"."
else
    echo_info "Downloading the repository to \"${DOT_ROOT}\"..."
    git clone https://github.com/umemotsu/dotfiles.git "${DOT_ROOT}"
fi

"${DOT_ROOT}/script/install.sh"
