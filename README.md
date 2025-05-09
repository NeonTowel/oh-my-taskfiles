# Oh-My-Taskfiles! 🚀

A powerful and extensible taskfile (go-task) based library to supercharge your daily development workflow.

---

## Why Oh-My-Taskfiles?

- **Modular & Extensible:** Easily include and manage taskfiles for different tools and languages.
- **Cross-Platform:** Works seamlessly on Linux, macOS, and Windows (WSL).
- **Pre-configured Tooling:** Comes with ready-to-use tasks for popular tools like Zsh, Starship, Git, and more.
- **Easy to Install & Update:** Simple installation script and update tasks to keep your setup fresh.
- **Customizable:** Drop your own taskfiles or override existing ones to tailor your workflow.

---

## Installation

Run the following command to install Oh-My-Taskfiles:

```bash
sh -c "$(curl --location https://raw.githubusercontent.com/NeonTowel/oh-my-taskfiles/refs/heads/main/install.sh)"
```

For Windows PowerShell, run this one-liner:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/NeonTowel/oh-my-taskfiles/refs/heads/main/install.ps1'))
```

This will:

- Clone the Oh-My-Taskfiles repository to `~/.omt`
- Install `go-task` CLI to `~/bin` (or via scoop on Windows)
- Provide you with an alias `omt` to run tasks easily

---

## Quick Start

After installation, add the following to your shell configuration (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export PATH=$HOME/bin:$PATH
alias omt='task -d $HOME/.omt'
```

Reload your shell configuration:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

Now you can run Oh-My-Taskfiles commands like:

```bash
omt update        # Update Oh-My-Taskfiles to the latest version
omt changelog     # Show recent updates and changes
omt tools:install # Install predefined tools like zsh, starship, etc.
omt               # run without arguments to see full list of tasks available
```

If you want to find out more details about a task (like the commands it is going to run), you can pass `--summary` flag to the command:

```bash
$ omt git:config-global --summary
task: git:config-global

[GIT] ✨ Configure git globally

dependencies:
 - tools:gum:install

commands:
 - user_name=$(gum input --placeholder "Enter your name")
user_email=$(gum input --placeholder "Enter your email")
echo "Set global user name to $user_name"
git config --global user.name "$user_name"
echo "Set global user email to $user_email"
git config --global user.email "$user_email"
echo "Set global core pager to gum"
git config --global core.pager "gum pager"
echo "Set global gpg format to ssh"
git config --global gpg.format "ssh"
echo "Set global commit.gpgsign to true"
git config --global commit.gpgsign true
echo "Set global pull.rebase to true"
git config --global pull.rebase true
```

And if you want to make a verbose dry-run (not actually run the tasks), you can pass `--dry --verbose` flags to the command:

```bash
$ omt git:config-global --dry --verbose
task: "git:config-global" started
task: "tools:gum:install" started
task: [tools:gum:install] if command -v gum >/dev/null 2>&1; then
  echo "gum is already installed."
else
  curl -fsSL "https://github.com/charmbracelet/gum/releases/download/v0.16.0/gum_0.16.0_Linux_x86_64.tar.gz" | sudo tar -xz -C $HOME/bin --strip-components=1 "gum_0.16.0_Linux_x86_64/gum"
  echo "gum has been installed successfully."
fi

task: "tools:gum:install" finished
task: [git:config-global] user_name=$(gum input --placeholder "Enter your name")
user_email=$(gum input --placeholder "Enter your email")
echo "Set global user name to $user_name"
git config --global user.name "$user_name"
echo "Set global user email to $user_email"
git config --global user.email "$user_email"
echo "Set global core pager to gum"
git config --global core.pager "gum pager"
echo "Set global gpg format to ssh"
git config --global gpg.format "ssh"
echo "Set global commit.gpgsign to true"
git config --global commit.gpgsign true
echo "Set global pull.rebase to true"
git config --global pull.rebase true

task: "git:config-global" finished
```

---

## Included Tools & Features

- **Zsh:** Install and configure Zsh shell with Oh My Zsh integration.
- **Starship:** Install and configure the Starship prompt.
- **Git:** Configure Git globally with handy aliases and settings.
- **Awesome-Git:** Install the awesome-git CLI tool for enhanced git experience.
- **Direnv, LSD, Bat, Gum:** Handy CLI tools for productivity.
- **Kubernetes:** Tasks for managing Kubernetes clusters.
- **Language Support:** Predefined tasks for Go, Rust, Node.js, and more.

Explore the `taskfile.yaml` and included taskfiles under `