// pkg/scripts/supported.go
package scripts

import (
	"log"

	"github.com/yourusername/vpsflow/pkg/osinfo"
)

var supportedScripts = map[string][]string{}

func LoadSupportedScripts(osInfo osinfo.OSInfo, pkgManager string) {
	// Define scripts based on package manager
	if pkgManager == "apt" {
		supportedScripts["nodejs"] = []string{"scripts/unix/apt/nodejs.sh"}
		supportedScripts["golang"] = []string{"scripts/unix/apt/golang.sh"}
		supportedScripts["python"] = []string{"scripts/unix/apt/python.sh"}
	} else if pkgManager == "brew" {
		supportedScripts["nodejs"] = []string{"scripts/macos/brew/nodejs.sh"}
		supportedScripts["golang"] = []string{"scripts/macos/brew/golang.sh"}
		supportedScripts["python"] = []string{"scripts/macos/brew/python.sh"}
	}
	log.Println("Supported scripts loaded for", osInfo.Name, "with", pkgManager)
}

func GetSupportedScripts() map[string][]string {
	return supportedScripts
}
