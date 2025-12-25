//go:build linux || darwin

package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func commandExists(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

func runCommand(name string, arg ...string) error {
	cmd := exec.Command(name, arg...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	fmt.Printf("\n> Running: %s %v\n", name, arg)
	return cmd.Run()
}

func runInstall() error {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("could not get user home directory: %w", err)
	}
	binDir := filepath.Join(homeDir, "bin")

	if _, err := os.Stat(binDir); os.IsNotExist(err) {
		fmt.Println("Creating directory:", binDir)
		if err := os.MkdirAll(binDir, 0755); err != nil {
			return fmt.Errorf("failed to create bin directory: %w", err)
		}
	}

	exePath, err := os.Executable()
	if err != nil {
		return fmt.Errorf("could not find executable path: %w", err)
	}
	// Name it 'omt' consistently, not 'omt.exe'
	destPath := filepath.Join(binDir, "omt")

	fmt.Printf("Installing omt to %s...\n", destPath)
	sourceFile, err := os.Open(exePath)
	if err != nil {
		return fmt.Errorf("failed to open source executable: %w", err)
	}
	defer sourceFile.Close()

	destFile, err := os.Create(destPath)
	if err != nil {
		return fmt.Errorf("failed to create destination file: %w", err)
	}
	defer destFile.Close()

	if _, err := io.Copy(destFile, sourceFile); err != nil {
		return fmt.Errorf("failed to copy executable: %w", err)
	}

	if err := os.Chmod(destPath, 0755); err != nil {
		return fmt.Errorf("failed to make executable: %w", err)
	}

	if !commandExists("git") {
		return fmt.Errorf("git is not installed. Please install git and run this command again")
	}
	fmt.Println("Git is already installed.")

	if !commandExists("task") {
		fmt.Println("Installing go-task...")
		// sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b $HOME/bin
		cmdStr := fmt.Sprintf("curl -sL https://taskfile.dev/install.sh | sh -s -- -d -b %s", binDir)
		if err := runCommand("sh", "-c", cmdStr); err != nil {
			return fmt.Errorf("failed to install go-task: %w", err)
		}
	} else {
		fmt.Println("go-task is already installed.")
	}

	omtPath := filepath.Join(homeDir, ".omt")
	if _, err := os.Stat(omtPath); os.IsNotExist(err) {
		fmt.Printf("Cloning oh-my-taskfiles repository to %s...\n", omtPath)
		if err := runCommand("git", "clone", "https://github.com/NeonTowel/oh-my-taskfiles.git", omtPath); err != nil {
			return fmt.Errorf("failed to clone repository: %w", err)
		}
	} else {
		fmt.Printf("Directory %s already exists, skipping clone.\n", omtPath)
	}

	return nil
}

func printFinalInstructions() {
	shell := os.Getenv("SHELL")
	profileFile := ""
	if strings.Contains(shell, "bash") {
		profileFile = "~/.bashrc"
	} else if strings.Contains(shell, "zsh") {
		profileFile = "~/.zshrc"
	} else {
		profileFile = "your shell profile file (e.g., ~/.bashrc, ~/.zshrc)"
	}

	fmt.Printf("\nTo complete the setup, please add the following line to %s:\n", profileFile)
	fmt.Println()
	fmt.Println("  export PATH=$HOME/bin:$PATH")
	fmt.Println()
	fmt.Println("Then, reload your shell configuration by running:")
	if profileFile != "" {
		fmt.Printf("  source %s\n", profileFile)
	} else {
		fmt.Println("  source <your_profile_file>")
	}
}
