HOMEBREW_PREFIX="${HOME}/.linuxbrew"

if [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
    eval $("${HOMEBREW_PREFIX}/bin/brew" shellenv)
fi
