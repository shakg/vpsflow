// handlers/homepage.go
package handlers

import (
	"fmt"
	"html/template"
	"log"
	"net/http"

	"github.com/shakg/vpsflow/pkg/scripts"
)

func HomepageHandler(w http.ResponseWriter, r *http.Request) {
	tmpl := template.Must(template.ParseFiles("templates/index.templ.html"))
	if err := tmpl.Execute(w, scripts.GetSupportedScripts()); err != nil {
		log.Printf("Failed to render homepage: %v", err)
	}
}

func InstallHandler(w http.ResponseWriter, r *http.Request) {
	packageName := r.URL.Query().Get("package")
	supportedScripts := scripts.GetSupportedScripts()

	if scriptPaths, ok := supportedScripts[packageName]; ok {
		log.Printf("Installing %s...", packageName)
		for _, script := range scriptPaths {
			go runScript(script) // Run in the background to allow streaming status
		}
		fmt.Fprintf(w, "Installation started for %s", packageName)
	} else {
		http.Error(w, "Package not supported", http.StatusNotFound)
	}
}

func runScript(scriptPath string) {
	log.Printf("Running script: %s", scriptPath)
	// Add logic to execute the script and stream output
}
