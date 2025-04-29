#!/usr/bin/env bash

echo "Installing Oh-My-Taskfiles..."

if [ ! -d "$HOME/.omt" ]; then
  git clone https://github.com/NeonTowel/oh-my-taskfiles.git "$HOME/.omt"

  if ! mkdir -p "$HOME/bin"; then
    echo "ERROR: Failed to create $HOME/bin directory!"
    exit 1
  fi

  echo "Installing go-task to $HOME/bin..."
  (sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b $HOME/bin) || (
    echo "ERROR: Go-task installation failed, aborting!"
    exit 1
  )

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