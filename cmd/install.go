package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

// installCmd represents the install command
var installCmd = &cobra.Command{
	Use:   "install",
	Short: "Installs oh-my-taskfiles and its dependencies",
	Long: `Performs a cross-platform installation of oh-my-taskfiles.

This includes:
- Placing the 'omt' binary in your user bin directory (linux/darwin).
- Ensuring dependencies like Git and go-task are installed.
- Cloning the repository to the ~/.omt directory.
- Providing instructions for finalizing shell setup (linux/darwin).`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Starting OMT installation...")
		if err := runInstall(); err != nil {
			fmt.Printf("Installation failed: %v", err)
		} else {
			fmt.Println("Installation complete.")
			printFinalInstructions()
		}
	},
}

func init() {
	rootCmd.AddCommand(installCmd)
}
