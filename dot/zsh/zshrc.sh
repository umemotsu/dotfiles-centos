export PATH="${HOME}/bin:${PATH}"

if [ -d "${HOME}/.zsh/inits" ]; then
    for config_file in $(find "${HOME}/.zsh/inits" -name "*.sh" | sort); do
        source "${config_file}"
    done
fi
