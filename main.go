// main.go
package main

import (
	"log"
	"net/http"

	"github.com/shakg/vpsflow/handlers"
	"github.com/shakg/vpsflow/pkg/osinfo"
	"github.com/shakg/vpsflow/pkg/scripts"
)

func main() {
	// Fetch OS and package manager info
	osInfo := osinfo.GetOSInfo()
	pkgManager := osinfo.GetPackageManager(osInfo)

	// Log OS and package manager info for debugging
	log.Printf("Detected OS: %s", osInfo.Name)
	log.Printf("Detected Package Manager: %s", pkgManager)

	// Pass OS and package manager information to script handler
	scripts.LoadSupportedScripts(osInfo, pkgManager)

	// Setup routes
	http.HandleFunc("/", handlers.HomepageHandler)
	http.HandleFunc("/install", handlers.InstallHandler)

	// Start server
	log.Println("Starting VPSFlow server on :8080...")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
