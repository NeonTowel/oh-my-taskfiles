# Add custom bin directories to PATH
$env:Path += ";$HOME\bin"

# Function to deduplicate PATH, and ensure that the PATH contains User and System PATHs as well.
function deduplicate-path() {
    # Get user and system PATH from registry
    $userPath = (Get-ItemProperty -Path "HKCU:\Environment" -Name Path).Path
    $systemPath = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name Path).Path

    # Split paths to arrays, filter out empty entries, combine, and deduplicate
    $mergedPath = @($systemPath, $userPath, $env:PATH) -join ';' `
        -split ';' | Where-Object { $_.Trim() -ne '' } | 
        ForEach-Object { $_.Trim() } |
        Select-Object -Unique

    # Join back into a single PATH string
    $finalPath = ($mergedPath -join ';')

    # Set the new PATH
    $env:PATH = $finalPath
}

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
    $env:DIRENV_CONFIG = "$HOME\.direnv\conf"
    $env:XDG_CACHE_HOME = "$HOME\.direnv\cache"
    $env:XDG_DATA_HOME = "$HOME\.direnv\data"
    $env:HOME = "$HOME"
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
} else {
    if (Test-Path "$HOME\scoop\apps\nvm\current\nvm.exe") {
        $env:PATH += ";$HOME\scoop\apps\nvm\current\"
        $env:PATH += ";$HOME\scoop\apps\nvm\current\nodejs\nodejs"
        $env:NVM_HOME = "$HOME\scoop\apps\nvm\current"
        $env:NVM_SYMLINK = "$HOME\scoop\apps\nvm\current\nodejs\nodejs"
    }
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

# Dotnet configuration
if (Test-Path "C:\Program Files\dotnet\dotnet.exe") {
    $env:Path += ";C:\Program Files\dotnet"
}

# Deduplicate PATH
deduplicate-path