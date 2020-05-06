# 補完される前にオリジナルのコマンドまで展開してチェックする
setopt complete_aliases
# 便利コマンドたち
if [[ "$(uname)" = "Darwin" ]]; then
    alias ls='ls -FG'
else
    alias ls='ls -F --color=auto'
fi
alias ll='ls -lh'
alias la='ls -A'
alias lla='ll -A'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sudo='env PATH=${PATH}:/sbin:/usr/sbin:/usr/local/sbin \sudo'
alias screen='screen -U'
alias emacs='env TERM=xterm-256color \emacs'
# emacsclient関係
alias ec='env TERM=xterm-256color \emacsclient -nw -a ""'
alias ec_kill='emacsclient -e "(kill-emacs)"'
# makeのエラー出力に色付け
e_normal=`echo -e "\033[0;30m"`
e_RED=`echo -e "\033[1;31m"`
e_BLUE=`echo -e "\033[1;36m"`

function make() {
    LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot\sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}
