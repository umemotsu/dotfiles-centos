if [ -d "${HOME}/.linuxbrew" ]; then
    HOMEBREW_PREFIX="${HOME}/.linuxbrew"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
else
    HOMEBREW_PREFIX=""
fi

if [ -n "${HOMEBREW_PREFIX}" ] && [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
    eval $("${HOMEBREW_PREFIX}/bin/brew" shellenv)
fi
