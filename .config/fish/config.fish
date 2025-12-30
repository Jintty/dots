if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting "~0.o~"

zoxide init fish | source
direnv hook fish | source

alias ff="fastfetch"
alias ls="lsd -la"
alias lg="lazygit"
alias gdb="gdb -q"
alias cat="bat"
alias cdh="cd ~"
alias cdw="cd ~/workspace/"

# Check or Query installed packages.
alias lspkg="paru -Qe"
alias lshist="grep 'installed' /var/log/pacman.log | tail -n 20"
alias fzpkg="paru -Qq | fzf --preview 'paru -Qil {}' --layout=reverse"

# lazygit manage dotfiles
alias lgdot='lazygit --git-dir=$HOME/.dots/ --work-tree=$HOME'
# bare git
function dot
    /usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME $argv
end
