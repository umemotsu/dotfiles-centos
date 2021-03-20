if [ "$(uname -m)" = "arm64" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi

if [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
    eval $("${HOMEBREW_PREFIX}/bin/brew" shellenv)
fi
