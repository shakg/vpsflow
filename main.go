// main.go
package main

import (
	"log"
	"net/http"

	"github.com/shakg/vpsflow/handlers"
	"github.com/shakg/vpsflow/pkg/osinfo"
)

func main() {
	// Fetch OS and package manager info
	osInfo := osinfo.GetOSInfo()

	// Log OS and package manager info for debugging
	log.Printf("Detected OS: %s", osInfo.OS)
	log.Printf("Detected Package Manager: %s", osInfo.PackageManager)

	// Setup routes
	http.HandleFunc("/", handlers.HomepageHandler)
	http.HandleFunc("/install", handlers.InstallHandler)

	// Start server
	log.Println("Starting VPSFlow server on :8080...")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
