package main

import (
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"

	"github.com/spf13/cobra"
)

func main() {
	Execute()
}

var (
	list      bool
	listAll   bool
	dry       bool
	force     bool
	silent    bool
	parallel  bool
	summary   bool
	verbose   bool
	yes       bool
)

var rootCmd = &cobra.Command{
	Use:   "omt [task]",
	Short: "A wrapper for go-task to provide a project-specific task runner.",
	Long:  `A CLI wrapper for go-task that hardcodes the taskfile directory to ~/.omt, allowing for a globally accessible, project-specific set of tasks.`,
	Run: func(cmd *cobra.Command, args []string) {
		currentUser, err := user.Current()
		if err != nil {
			fmt.Println("Error getting current user:", err)
			os.Exit(1)
		}
		taskDir := filepath.Join(currentUser.HomeDir, ".omt")

		baseCmd := "task"
		cmdArgs := []string{"--dir", taskDir}

		if list {
			cmdArgs = append(cmdArgs, "--list")
		}
		if listAll {
			cmdArgs = append(cmdArgs, "--list-all")
		}
		if dry {
			cmdArgs = append(cmdArgs, "--dry")
		}
		if force {
			cmdArgs = append(cmdArgs, "--force")
		}
		if silent {
			cmdArgs = append(cmdArgs, "--silent")
		}
		if parallel {
			cmdArgs = append(cmdArgs, "--parallel")
		}
		if summary {
			cmdArgs = append(cmdArgs, "--summary")
		}
		if verbose {
			cmdArgs = append(cmdArgs, "--verbose")
		}
		if yes {
			cmdArgs = append(cmdArgs, "--yes")
		}

		cmdArgs = append(cmdArgs, args...)

		execCmd := exec.Command(baseCmd, cmdArgs...)
		execCmd.Stdout = os.Stdout
		execCmd.Stderr = os.Stderr
		execCmd.Stdin = os.Stdin

		if err := execCmd.Run(); err != nil {
			if exitError, ok := err.(*exec.ExitError); ok {
				os.Exit(exitError.ExitCode())
			} else {
				fmt.Println("Error executing command:", err)
				os.Exit(1)
			}
		}
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.Flags().BoolVar(&list, "list", false, "lists tasks with descriptions")
	rootCmd.Flags().BoolVar(&listAll, "list-all", false, "lists all tasks, including internal ones")
	rootCmd.Flags().BoolVar(&dry, "dry", false, "compiles and prints tasks in the order that they would be run, but it does not execute them")
	rootCmd.Flags().BoolVar(&force, "force", false, "forces execution even when the task is up-to-date")
	rootCmd.Flags().BoolVar(&silent, "silent", false, "disables echoing commands before executing")
	rootCmd.Flags().BoolVar(&parallel, "parallel", false, "executes tasks in parallel")
	rootCmd.Flags().BoolVar(&summary, "summary", false, "show summary of a task")
	rootCmd.Flags().BoolVarP(&verbose, "verbose", "v", false, "enables verbose mode")
	rootCmd.Flags().BoolVarP(&yes, "yes", "y", false, "assumes 'yes' as answer to all prompts")
	rootCmd.SetFlagErrorFunc(func(c *cobra.Command, err error) error {
		c.Println(err)
		c.Println(c.UsageString())
		return nil
	})
}
