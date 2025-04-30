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

This will:

- Clone the Oh-My-Taskfiles repository to `~/.omt`
- Install `go-task` CLI to `~/bin`
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
omt update       # Update Oh-My-Taskfiles to the latest version
omt changelog    # Show recent updates and changes
omt tools:install # Install predefined tools like zsh, starship, etc.
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

Explore the `taskfile.yaml` and included taskfiles under `tools/` and `lang/` directories for full capabilities.

---

## Updating Oh-My-Taskfiles

Keep your Oh-My-Taskfiles installation up to date by running:

```bash
omt update
```

This will fetch the latest changes from the repository and apply them.

---

## Contributing

Contributions are welcome! Whether it's adding new tasks, improving documentation, or fixing bugs:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

Please follow the existing taskfile structure and conventions.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Stay Connected

Follow the repository for updates and new features!

---

Happy tasking! 🎉
