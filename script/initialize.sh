#!/bin/bash

set -eu

DOT_ROOT="$(cd $(dirname $0)/.. && pwd)"
source "${DOT_ROOT}/script/utils.sh"

echo
echo_info "Initializing applications..."
for init_file in $(find "${DOT_ROOT}/etc" -type f -name "*.sh" | sort); do
    if [ ! -x "${init_file}" ]; then
        echo_warning "Ignore non-executable file (${init_file})."
        continue
    fi
    run_verbosely "${init_file}"
done
