use std/util "path add"

mkdir ($nu.data-dir | path join "vendor/autoload")

$env.config.show_banner = false

alias cls = clear

[
    [lsd "alias l = lsd"]
    [lsd "alias ll = lsd -alh"]
    [lsd "alias ls = lsd"]
    [lsd "alias tree = lsd --tree"]
    [bat "alias cat = bat"]
    [bat "alias ccat = bat --style=-grid,-numbers --paging=never"]
    [git 'alias gl = git log --graph --pretty=format:"%C(white)%s%Creset" --abbrev-commit']
    [git "alias gll = git log --graph --decorate --pretty=oneline --abbrev-commit --all"]
    [git "alias gs = git status --renames"]
    [awesome-git "alias ag = awesome-git"]
    [kubectl "alias k = kubectl"]
    [helix "alias vim = helix"]
]
| where {|a| which $a.0 | is-not-empty }
| each {|a| $a.1 }
| str join (char nl)
| save -f ($nu.data-dir | path join "vendor/autoload/aliases.nu")

let home = $nu.home-dir
let nvm = ($home | path join "scoop/apps/nvm/current")

[
    ($home | path join "bin")
    ($home | path join ".bun/bin")
    ($home | path join ".local/bin")
    'C:\usr\local\go\bin'
    ($home | path join ".cargo/bin")
    'C:\Program Files\dotnet'
    ($env.LOCALAPPDATA | path join "pnpm/bin")
    ($home | path join "google-cloud-sdk/bin")
    $nvm
    ($nvm | path join "nodejs/nodejs")
]
| where {|p| $p | path exists }
| path add --append ...$in

$env.AZURE_DEV_COLLECT_TELEMETRY = "no"

if (which direnv | is-not-empty) {
    $env.DIRENV_CONFIG = ($home | path join ".direnv/conf")
    $env.XDG_CACHE_HOME = ($home | path join ".direnv/cache")
    $env.XDG_DATA_HOME = ($home | path join ".direnv/data")
}

if ($nvm | path exists) {
    $env.NVM_HOME = $nvm
    $env.NVM_SYMLINK = ($nvm | path join "nodejs/nodejs")
}

if ($home | path join ".1password/agent.sock" | path exists) {
    $env.SSH_AUTH_SOCK = ($home | path join ".1password/agent.sock")
}

if (which claude | is-not-empty) {
    let bash = (
        ['C:\Program Files\Git\bin\bash.exe' ($home | path join "scoop/shims/bash.exe")]
        | where {|p| $p | path exists }
        | get 0?
    )
    if $bash != null { $env.CLAUDE_CODE_GIT_BASH_PATH = $bash }
}

if (which starship | is-not-empty) {
    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}
