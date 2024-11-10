# VPSFlow

**VPSFlow** is an open-source web server designed to simplify the process of setting up a fresh Virtual Private Server (VPS). With VPSFlow, you can configure your server effortlessly by installing essential software and packages with a single click. It's a straightforward solution to streamline deployments, whether you're looking to set up web applications, monitoring tools, or databases.

### Key Features

- **One-Click Installations**: Set up tools like Node.js, Hono.js, Angular, PostHog, Grafana, PostgreSQL, MySQL, and more in seconds.
- **Script Management**: Execute relevant scripts for your operating system and package manager, automatically selected based on your setup.
- **Dashboard Streaming**: Real-time installation status streamed to your dashboard.
- **Cross-Platform Support**: Includes scripts for Debian/Ubuntu, CentOS/RHEL, macOS, and Windows environments.

### MVP Roadmap

1. **Detect OS and Package Manager**: Automatically identify the user's operating system and available package manager(s).
2. **Select Relevant Scripts**: Based on the OS information, pull the correct setup scripts.
3. **Display Setup Options**: List available scripts for one-click setup on the homepage.
4. **Trigger Installation**: When a user clicks to set up a package (e.g., PostgreSQL), VPSFlow runs the appropriate script.
5. **Stream Installation Status**: Display real-time installation feedback on the dashboard.
6. **Verify Installation**: Run tests to confirm successful setup and report status.

### Project Structure

```plaintext
vpsflow/
├── main.go                         // Main entry point for VPSFlow
├── pkg/
│   ├── osinfo/
│   │   └── osinfo.go               // Functions for OS information detection
│   ├── scripts/
│   │   ├── script.go               // Script management and execution
│   │   └── supported.go            // Definitions for supported scripts
├── templates/
│   └── index.templ.html            // Homepage template for Templ
├── handlers/
│   └── homepage.go                 // Handler functions for the web server
├── scripts/                        // Setup scripts, organized by OS and package manager
│   ├── unix/
│   │   ├── apt/                    // Debian-based package manager scripts
│   │   ├── snap/                   // Snap package manager scripts
│   │   └── yum/                    // Yum package manager scripts for RHEL/CentOS
│   ├── windows/
│   │   ├── chocolatey/             // Chocolatey package manager scripts
│   │   └── scoop/                  // Scoop package manager scripts
│   └── macos/
│       ├── brew/                   // Homebrew package manager scripts
│       └── native/                 // macOS native scripts (e.g., Xcode CLI)
├── go.mod                          // Go module dependencies
└── go.sum                          // Go checksum file
```

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/vpsflow.git
   cd vpsflow
   ```
2. Run the server:
   ```bash
   go run main.go
   ```

3. Open a browser and navigate to `http://localhost:8080` to start using VPSFlow.

### Contributing

Contributions are welcome! Feel free to open issue or PR. 