# config.nu
#
# Installed by:
# version = "0.112.2"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Clear the screen
alias cls = clear

alias l = lsd
alias ll = lsd -lh
alias ls = lsd
alias tree = ls --tree

alias cat = bat
alias ccat = bat --style=-grid,-numbers --paging=never

alias gl = git log --graph --pretty=format:"%C(white)%s%Creset" --abbrev-commit
alias gll = git log --graph --decorate --pretty=oneline --abbrev-commit
alias gs = git status --renames

alias ag = awesome-git

alias k = kubectl

alias vim = helix

$env.config.show_banner = false
