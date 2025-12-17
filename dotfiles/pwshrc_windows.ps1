$global:PWSH_PROFILE_START = Get-Date

$global:PWSH_CACHE_DIR = "$HOME\.cache\pwsh"
$global:PWSH_CACHE_VERSION = "1.0"

function Initialize-PwshCache {
    if (-not (Test-Path $global:PWSH_CACHE_DIR)) {
        New-Item -ItemType Directory -Path $global:PWSH_CACHE_DIR -Force | Out-Null
    }
}

function Get-CachedScript {
    param(
        [string]$Command,
        [string[]]$Arguments,
        [string]$CacheName,
        [string]$VersionCheck = $null
    )

    Initialize-PwshCache

    $cacheFile = "$global:PWSH_CACHE_DIR\$CacheName-v$global:PWSH_CACHE_VERSION.ps1"
    $versionFile = "$global:PWSH_CACHE_DIR\$CacheName-version.txt"

    $needsRefresh = $false

    if (-not (Test-Path $cacheFile)) {
        $needsRefresh = $true
    } elseif ($VersionCheck) {
        if (Test-Path $versionFile) {
            $cachedVersion = Get-Content $versionFile -Raw -ErrorAction SilentlyContinue
            if ($cachedVersion -ne $VersionCheck) {
                $needsRefresh = $true
            }
        } else {
            $needsRefresh = $true
        }
    }

    if ($needsRefresh) {
        & $Command @Arguments | Out-File $cacheFile -Encoding UTF8
        if ($VersionCheck) {
            $VersionCheck | Out-File $versionFile -Encoding UTF8
        }
    }

    return $cacheFile
}

$pathsToAdd = @(
    "$HOME\bin"
    "$HOME\.local\bin"
)

function deduplicate-path() {
    if ($global:PATH_DEDUPLICATED) { return }

    $userPath = (Get-ItemProperty -Path "HKCU:\Environment" -Name Path).Path
    $systemPath = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name Path).Path

    $mergedPath = @($systemPath, $userPath, $env:PATH) -join ';' `
        -split ';' | Where-Object { $_.Trim() -ne '' } |
        ForEach-Object { $_.Trim() } |
        Select-Object -Unique

    $env:PATH = ($mergedPath -join ';')
    $global:PATH_DEDUPLICATED = $true
}

$global:__COMMANDS = @{}
@('which', 'lsd', 'bat', 'direnv', 'starship', 'task', 'awesome-git', 'helix', 'claude') | ForEach-Object {
    $global:__COMMANDS[$_] = [bool](Get-Command $_ -ErrorAction SilentlyContinue)
}

$global:__PATHS = @{}
@(
    @{Key='omt'; Path="$HOME\.omt\taskfile.yaml"},
    @{Key='gcloud_path'; Path="$HOME\google-cloud-sdk\path.ps1"},
    @{Key='gcloud_completion'; Path="$HOME\google-cloud-sdk\completion.ps1"},
    @{Key='go_bin'; Path="C:\usr\local\go\bin"},
    @{Key='cargo_env'; Path="$HOME\.cargo\env"},
    @{Key='cargo_bin'; Path="$HOME\.cargo\bin"},
    @{Key='nvm_ps1'; Path="$HOME\.nvm\nvm.ps1"},
    @{Key='nvm_scoop'; Path="$HOME\scoop\apps\nvm\current\nvm.exe"},
    @{Key='agent_bridge'; Path="$HOME\.agent-bridge.ps1"},
    @{Key='1password_sock'; Path="$HOME\.1password\agent.sock"},
    @{Key='dotnet'; Path="C:\Program Files\dotnet\dotnet.exe"}
) | ForEach-Object {
    $global:__PATHS[$_.Key] = Test-Path $_.Path
}

if (-not $global:__COMMANDS['which']) {
    function which($command) { Get-Command $command | ForEach-Object { $_.Source } }
}

function find($path, $pattern) {
    Get-ChildItem -Path $path -Filter $pattern -Recurse | ForEach-Object { echo $_.FullName }
}

if ($global:__COMMANDS['lsd']) {
    function l { lsd @args }
    function ll { lsd -alh @args }
    function ls { lsd @args }
    function tree { lsd --tree @args }
}

if ($global:__COMMANDS['bat']) {
    Set-Alias cat "bat"
    function ccat { bat --style=-grid,-numbers --paging=never @args }
}

function gl { git log --graph --decorate --pretty=oneline --abbrev-commit @args }
function gs { git status --renames @args }

if ($global:__PATHS['omt']) {
    function omt { task -t "$HOME\.omt\taskfile.yaml" @args }
}

if ($global:__PATHS['gcloud_path']) {
    . "$HOME\google-cloud-sdk\path.ps1"
}

if ($global:__PATHS['gcloud_completion']) {
    $global:GCLOUD_COMPLETION_LOADED = $false
    function gcloud {
        if (-not $global:GCLOUD_COMPLETION_LOADED) {
            . "$HOME\google-cloud-sdk\completion.ps1"
            $global:GCLOUD_COMPLETION_LOADED = $true
        }
        & (Get-Command -Name gcloud -CommandType Application) @args
    }
}

if ($global:__COMMANDS['direnv']) {
    $env:DIRENV_CONFIG = "$HOME\.direnv\conf"
    $env:XDG_CACHE_HOME = "$HOME\.direnv\cache"
    $env:XDG_DATA_HOME = "$HOME\.direnv\data"

    $global:DIRENV_LOADED = $false
    $global:DIRENV_HOOK_CACHE = "$global:PWSH_CACHE_DIR\direnv-hook.ps1"

    Initialize-PwshCache
    if (-not (Test-Path $global:DIRENV_HOOK_CACHE)) {
        direnv hook pwsh | Out-File $global:DIRENV_HOOK_CACHE -Encoding UTF8
    }

    $__original_prompt = $function:prompt
    function global:prompt {
        if (-not $global:DIRENV_LOADED) {
            . $global:DIRENV_HOOK_CACHE
            $global:DIRENV_LOADED = $true
        }
        if ($__original_prompt) {
            & $__original_prompt
        }
    }
}

if ($global:__COMMANDS['starship'] && $env:TERM != "dumb") {
    $starshipVersion = (starship --version 2>$null)
    $starshipCache = Get-CachedScript -Command 'starship' -Arguments @('init', 'powershell') -CacheName 'starship-init' -VersionCheck $starshipVersion
    . $starshipCache
}

if ($global:__COMMANDS['task']) {
    $taskCache = Get-CachedScript -Command 'task' -Arguments @('--completion', 'powershell') -CacheName 'task-completion'
    . $taskCache
}

if ($global:__PATHS['go_bin']) {
    $pathsToAdd += "C:\usr\local\go\bin"
}

if ($global:__PATHS['cargo_env']) {
    . "$HOME\.cargo\env"
} elseif ($global:__PATHS['cargo_bin']) {
    $pathsToAdd += "$HOME\.cargo\bin"
}

$nvmDir = "$HOME\.nvm"
if ($global:__PATHS['nvm_ps1']) {
    . "$nvmDir\nvm.ps1"
} elseif ($global:__PATHS['nvm_scoop']) {
    $nvmBase = "$HOME\scoop\apps\nvm\current"
    $pathsToAdd += $nvmBase
    $pathsToAdd += "$nvmBase\nodejs\nodejs"
    $env:NVM_HOME = $nvmBase
    $env:NVM_SYMLINK = "$nvmBase\nodejs\nodejs"
}

if ($global:__COMMANDS['awesome-git']) {
    Set-Alias ag "awesome-git"
}

if ($global:__PATHS['agent_bridge']) {
    . "$HOME\.agent-bridge.ps1"
    if ($global:__PATHS['1password_sock']) {
        $env:SSH_AUTH_SOCK = "$HOME\.1password\agent.sock"
    }
}

if ($global:__COMMANDS['helix']) {
    Set-Alias vim "helix"
}

if ($global:__PATHS['dotnet']) {
    $pathsToAdd += "C:\Program Files\dotnet"
}

# Claude configuration
if ($global:__COMMANDS['claude']) {
    if(Test-Path "C:\Program Files\Git\bin\bash.exe") {
        $env:CLAUDE_CODE_GIT_BASH_PATH = "C:\Program Files\Git\bin\bash.exe"
    } else {
        if(Test-Path "$HOME\scoop\shims\bash.exe") {
            $env:CLAUDE_CODE_GIT_BASH_PATH = "$HOME\scoop\shims\bash.exe"
        }
    }
}

if ($pathsToAdd.Count -gt 0) {
    $env:Path += ";" + ($pathsToAdd -join ';')
}

if ([Environment]::UserInteractive) {
    deduplicate-path

    $profileLoadTime = (Get-Date) - $global:PWSH_PROFILE_START
    Write-Host "⚡ Profile loaded in $([math]::Round($profileLoadTime.TotalMilliseconds))ms" -ForegroundColor Green
}
