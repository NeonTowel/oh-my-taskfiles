//go:build windows

package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
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
	destPath := filepath.Join(binDir, filepath.Base(exePath))

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

	if !commandExists("scoop") {
		fmt.Println("Installing Scoop...")
		psCmd := "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; irm get.scoop.sh | iex"
		if err := runCommand("powershell", "-Command", psCmd); err != nil {
			return fmt.Errorf("failed to install scoop: %w", err)
		}
	} else {
		fmt.Println("Scoop is already installed.")
	}

	if !commandExists("git") {
		fmt.Println("Installing Git...")
		if err := runCommand("scoop", "install", "git"); err != nil {
			return fmt.Errorf("failed to install git with scoop: %w", err)
		}
	} else {
		fmt.Println("Git is already installed.")
	}

	if !commandExists("task") {
		fmt.Println("Installing go-task...")
		if err := runCommand("scoop", "install", "task"); err != nil {
			return fmt.Errorf("failed to install go-task with scoop: %w", err)
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
	fmt.Println("\nTo complete the setup, please add the OMT bin directory to your PATH.")
	fmt.Println("You can do this by running the following command in PowerShell:")
	fmt.Println()
	fmt.Println(`  [Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'User') + ";$HOME\bin", 'User')`)
	fmt.Println()
	fmt.Println("\nAfter running this, you must restart your terminal for the changes to take effect.")
	fmt.Println("You can then run 'omt' from anywhere.")
}
