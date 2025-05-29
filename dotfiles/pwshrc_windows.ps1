# Add custom bin directories to PATH
$env:Path += ";$HOME\bin"

# Aliases for lsd (if installed)
if (Get-Command lsd -ErrorAction SilentlyContinue) {
    function l { lsd @args }
    function ll { lsd -alh @args }
    function tree { lsd --tree @args }
}

# Aliases for bat (if installed)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias cat "bat"
    function ccat { bat --style=-grid,-numbers --paging=never @args }
}

# Git aliases
function gl { git log --graph --decorate --pretty=oneline --abbrev-commit @args }
function gs { git status --renames @args }

# Oh-My-Taskfiles configuration
if (Test-Path "$HOME\.omt\taskfile.yaml") {
    function omt { task -t "$HOME\.omt\taskfile.yaml" @args }
}

# Google Cloud SDK (if present)
if (Test-Path "$HOME\google-cloud-sdk\path.ps1") {
    . "$HOME\google-cloud-sdk\path.ps1"
}
if (Test-Path "$HOME\google-cloud-sdk\completion.ps1") {
    . "$HOME\google-cloud-sdk\completion.ps1"
}

# Direnv (if installed)
if (Get-Command direnv -ErrorAction SilentlyContinue) {
    Invoke-Expression "$(direnv hook pwsh)"
}

# Starship prompt (if installed)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell | Out-String)
}

# Go-task completion (if installed)
if (Get-Command task -ErrorAction SilentlyContinue) {
    Invoke-Expression (&task --completion powershell | Out-String)
}

# Go binary path
$goBin = "C:\usr\local\go\bin"
if (Test-Path $goBin) {
    $env:Path += ";$goBin"
}

# Rust configuration
if (Test-Path "$HOME\.cargo\env") {
    . "$HOME\.cargo\env"
} else {
    if (Test-Path "$HOME\.cargo\bin") {
        $env:Path += ";$HOME\.cargo\bin"
    }
}

# Node/NVM (PowerShell support is limited, but you can try)
$nvmDir = "$HOME\.nvm"
if (Test-Path "$nvmDir\nvm.ps1") {
    . "$nvmDir\nvm.ps1"
}

# Awesome-git alias
if (Get-Command awesome-git -ErrorAction SilentlyContinue) {
    Set-Alias ag "awesome-git"
}

# 1Password SSH Agent bridge for WSL
if (Test-Path "$HOME\.agent-bridge.ps1") {
    . "$HOME\.agent-bridge.ps1"
    if (Test-Path "$HOME\.1password\agent.sock") {
        $env:SSH_AUTH_SOCK = "$HOME\.1password\agent.sock"
    }
}

# Helix configuration
if (Get-Command helix -ErrorAction SilentlyContinue) {
    Set-Alias vim "helix"
}