// handlers/homepage.go
package handlers

import (
	"bufio"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/shakg/vpsflow/pkg/osinfo"
	"github.com/shakg/vpsflow/pkg/scripts"
)

type Tool struct {
	ID               int
	Name             string
	Description      string
	SupportedVersion string
	LastUpdate       string
	Installed        bool
	InstalledVersion string
	Category         string
}

type PageData struct {
	OSInfo osinfo.OSInfo
	Tools  []Tool
}

func HomepageHandler(w http.ResponseWriter, r *http.Request) {
	// Fetch OS information using osinfo package
	osInfo := osinfo.GetOSInfo()
	// Scan the tools directory to gather available tools
	tools, err := getAvailableTools("scripts", osInfo.OS, osInfo.PackageManager)
	if err != nil {
		log.Println("Error getting tools:", err)
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		return
	}

	// Categories for filtering in the UI

	// Prepare data for template rendering
	pageData := PageData{
		OSInfo: osInfo,
		Tools:  tools,
	}
	// Parse HTML template
	tmpl := template.Must(template.ParseFiles("templates/index.templ.html"))

	// Render the template with data
	err = tmpl.Execute(w, pageData)
	if err != nil {
		log.Println("Error executing template:", err)
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
	}
}

// Helper function to get available tools from the tools directory
func getAvailableTools(basePath string, osName string, osPackageManager string) ([]Tool, error) {
	tools := []Tool{}
	toolID := 1

	// Start from the specified OS folder
	osPath := filepath.Join(basePath, osName, osPackageManager)

	err := filepath.Walk(osPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Check if it's a directory
		if !info.IsDir() && path != osPath {
			// Check if there's a .sh file named after the directory
			if fileInfo, err := os.Stat(path); err == nil && fileInfo.Size() > 0 {
				// Collect tool information
				tool, err := parseMetadata(path)
				if err != nil {
					return err
				}
				tools = append(tools, tool)
				toolID++
			}
		}
		return nil
	})

	if err != nil {
		return nil, err
	}
	return tools, nil
}

func parseMetadata(filePath string) (Tool, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return Tool{}, err
	}
	defer file.Close()

	tool := Tool{}
	scanner := bufio.NewScanner(file)

	// Parse comment lines for metadata
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "#") {
			// Remove "#" and whitespace for processing
			line = strings.TrimSpace(line[1:])
			parts := strings.SplitN(line, ":", 2)
			if len(parts) == 2 {
				key := strings.TrimSpace(parts[0])
				value := strings.TrimSpace(parts[1])

				// Assign values to the Tool struct based on key
				switch key {
				case "Name":
					tool.Name = value
				case "SupportedVersion":
					tool.SupportedVersion = value
				case "Category":
					tool.Category = value
				case "Description":
					tool.Description = value
				case "LastUpdate":
					tool.LastUpdate = value
				}
			}
		} else {
			// Stop parsing if we hit non-commented lines (script content)
			break
		}
	}

	if err := scanner.Err(); err != nil {
		return Tool{}, err
	}

	return tool, nil
}

func InstallHandler(w http.ResponseWriter, r *http.Request) {
	packageName := r.URL.Query().Get("package")
	log.Println(packageName)

	// Set headers for SSE (only once)
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")

	// Write status code once (before streaming data)
	w.WriteHeader(http.StatusOK)

	// Stream the installation start message
	fmt.Fprintf(w, "data: Installation started for %s\n\n", packageName)

	// Retrieve the flusher interface
	flusher, ok := w.(http.Flusher)
	if !ok {
		log.Println("Error: ResponseWriter does not support flushing")
		return
	}

	// Make sure to flush immediately after sending data
	flusher.Flush()

	// Define script path (update based on your system)
	osPath := filepath.Join("scripts", "darwin", "brew", "nodejs.sh")

	// Execute the script and stream its output in the background
	go runScriptAndStreamOutput(osPath, w, flusher)
}

// runScriptAndStreamOutput executes the script and streams the output to the client
func runScriptAndStreamOutput(scriptPath string, w http.ResponseWriter, flusher http.Flusher) {
	// Log the state of the writer and flusher
	if w == nil {
		log.Println("Error: ResponseWriter is nil in runScriptAndStreamOutput")
		return
	}
	if flusher == nil {
		log.Println("Error: Flusher is nil in runScriptAndStreamOutput")
		return
	}

	// Execute the script and handle output
	err := scripts.ExecuteScript(scriptPath, func(output string) {
		// Check if writer and flusher are still valid before attempting to write
		if w != nil && flusher != nil {
			// Stream the output to the client in real-time
			_, writeErr := fmt.Fprintf(w, "data: %s\n\n", output)
			if writeErr != nil {
				log.Printf("Error writing output: %s", writeErr.Error())
				return
			}
			flusher.Flush() // Ensure the data is sent to the client
		} else {
			log.Println("Error: ResponseWriter or Flusher is nil during output streaming")
		}
	})

	// If there's an error in script execution, report it
	if err != nil {
		if w != nil && flusher != nil {
			_, writeErr := fmt.Fprintf(w, "data: ERROR: %s\n\n", err.Error())
			if writeErr != nil {
				log.Printf("Error writing error message: %s", writeErr.Error())
			}
			flusher.Flush()
		} else {
			log.Println("Error: ResponseWriter or Flusher is nil while reporting the error")
		}
	}
}
