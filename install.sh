#!/usr/bin/env bash

echo "Installing Oh-My-Taskfiles..."

if [ ! -d "$HOME/.omt" ]; then
  echo "Cloning to $HOME/.omt..."
  git clone https://github.com/NeonTowel/oh-my-taskfiles.git "$HOME/.omt"

  echo "Installing go-task to $HOME/bin..."
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b $HOME/bin

  echo "To complete the setup, please add the following to your ~/.bashrc file:"
  echo
  echo "  export PATH=\$HOME/.omt/bin:\$PATH"
  echo "  alias omt='task -d $HOME/.omt'"
  echo
  echo "Then, reload your bash configuration by running:"
  echo "  source ~/.bashrc"
  echo
  echo "Adapt the above for other shells (zsh, fish, etc)."


else
  echo "Directory $HOME/.omt already exists, aborting..."
fi