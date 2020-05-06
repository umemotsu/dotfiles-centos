echo_info() {
    _echo_log "\033[32m$*\033[m"
}

echo_error() {
    _echo_log "\033[31m$*\033[m"
}

_echo_log() {
    echo -e "dotfiles: \033[1m$*\033[m"
}
