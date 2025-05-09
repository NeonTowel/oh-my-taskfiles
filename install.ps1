# Check if Scoop is installed, if not install it
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
} else {
    Write-Host "Scoop is already installed."
}

# Install Git if not installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..."
    scoop install git
} else {
    Write-Host "Git is already installed."
}

# Install go-task if not installed
if (-not (Get-Command task -ErrorAction SilentlyContinue)) {
    Write-Host "Installing go-task..."
    scoop install task
} else {
    Write-Host "go-task is already installed."
}

# Clone the oh-my-taskfiles repo if not already cloned
$omtPath = "$HOME\.omt"
if (-not (Test-Path $omtPath)) {
    Write-Host "Cloning oh-my-taskfiles repository to $omtPath..."
    git clone https://github.com/NeonTowel/oh-my-taskfiles.git $omtPath
} else {
    Write-Host "Directory $omtPath already exists, aborting..."
}

Write-Host "To complete the setup, please add the following to your PowerShell profile (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1):"
Write-Host
Write-Host '$env:Path += ";$HOME\bin"'
Write-Host 'function omt { task -d "$HOME\.omt\" @args }'
Write-Host
Write-Host "Then reload your profile by running:"
Write-Host "  . $PROFILE" 