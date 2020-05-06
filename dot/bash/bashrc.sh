export PATH="${HOME}/bin:${PATH}"

if [ -d "${HOME}/.bash/inits" ]; then
    for config_file in $(find "${HOME}/.bash/inits" -name "*.sh" | sort); do
        source "${config_file}"
    done
fi
