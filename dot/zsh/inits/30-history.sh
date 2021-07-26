# 履歴の保存先
HISTFILE="${HOME}/.zsh-history"
# メモリに展開する履歴の数
HISTSIZE=10000
# 保存する履歴の数
SAVEHIST=10000
# ヒストリ全体でのコマンドの重複を禁止する
setopt hist_ignore_dups
# コマンドの空白をけずる
setopt hist_reduce_blanks
# historyコマンドはログに記述しない
setopt hist_no_store
# 先頭が空白だった場合はログに残さない
setopt hist_ignore_space
# 履歴ファイルに時刻を記録
setopt extended_history
# シェルのプロセスごとに履歴を共有
setopt share_history
# 複数のzshを同時に使うときなどhistoryファイルに上書きせず追加
setopt append_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 履歴検索機能のショートカット設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# インクリメンタルサーチの設定
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
# 全履歴の一覧を出力する
function history-all {
    history -E 1
}
