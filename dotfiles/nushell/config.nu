# config.nu
alias cls = clear

alias l = lsd
alias ll = lsd -lh
alias ls = lsd
alias tree = ls --tree

alias cat = bat
alias ccat = bat --style=-grid,-numbers --paging=never

alias gl = git log --graph --pretty=format:"%C(white)%s%Creset" --abbrev-commit
alias gll = git log --graph --decorate --pretty=oneline --abbrev-commit --all
alias gs = git status --renames

alias ag = awesome-git

alias k = kubectl

alias vim = helix

$env.config.show_banner = false

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
