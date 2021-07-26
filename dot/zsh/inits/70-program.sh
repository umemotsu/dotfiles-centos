# source-highlight
if type src-hilite-lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN="| src-hilite-lesspipe.sh %s"
    export LESS="-R"
fi

# colordiff
if type colordiff >/dev/null 2>&1; then
    alias diff='colordiff -u'
else
    alias diff='diff -u'
fi
