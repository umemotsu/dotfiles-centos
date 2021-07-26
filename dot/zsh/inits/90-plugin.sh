if type brew >/dev/null 2>&1; then
    ZPLUG_HOME="$(brew --prefix)/opt/zplug"

    if [ -d "${ZPLUG_HOME}" ]; then
        export ZPLUG_HOME
        source "${ZPLUG_HOME}/init.zsh"

        # Helpers
        zplug "zsh-users/zsh-syntax-highlighting", defer:2
        zplug "zsh-users/zsh-history-substring-search", defer:3
        zplug "zsh-users/zsh-autosuggestions"
        zplug "zsh-users/zsh-completions", depth:1
        zplug "b4b4r07/enhancd", use:init.sh

        # Themes
        zplug "modules/git", from:prezto
        zplug "modules/prompt", from:prezto
        zstyle ":prezto:module:prompt" theme "pure"

        # Auto-install new plugins
        if ! zplug check --verbose; then
            printf "Install? [y/N]: "
            if read -q; then
                echo; zplug install
            fi
        fi

        # Load plugins
        zplug load # --verbose

        # Post-load configurations
        if zplug check "zsh-users/zsh-history-substring-search"; then
            bindkey -M emacs "^P" history-substring-search-up
            bindkey -M emacs "^N" history-substring-search-down
        fi
    fi
fi
