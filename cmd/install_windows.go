//go:build windows

package main

import (
	"fmt"
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

	homeDir, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("could not get user home directory: %w", err)
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
	fmt.Println("OMT installed successfully.")
}
