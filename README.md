```
npm install
npm run dev
```

```
open http://localhost:3000
```

vpsflow/
├── main.go
├── pkg/
│   ├── osinfo/
│   │   └── osinfo.go              // Functions for OS information
│   ├── scripts/
│   │   ├── script.go              // Script management and execution
│   │   └── supported.go           // Script definitions and logic
├── templates/
│   └── index.templ.html           // Homepage template for Templ
├── handlers/
│   └── homepage.go                // Handler functions
├── assets/
│   └── styles.css                 // CSS for dashboard styling
├── scripts/                       // All setup scripts categorized by OS and package manager
│   ├── unix/
│   │   ├── apt/                   // Debian-based package manager scripts
│   │   │   ├── nodejs.sh
│   │   │   ├── golang.sh
│   │   │   └── python.sh
│   │   ├── snap/                  // Snap package manager scripts
│   │   │   ├── nodejs.sh
│   │   │   ├── golang.sh
│   │   │   └── python.sh
│   │   └── yum/                   // Yum package manager (for RHEL/CentOS-based systems)
│   │       ├── nodejs.sh
│   │       ├── golang.sh
│   │       └── python.sh
│   ├── windows/
│   │   ├── chocolatey/            // Chocolatey package manager scripts
│   │   │   ├── nodejs.bat
│   │   │   ├── golang.bat
│   │   │   └── python.bat
│   │   └── scoop/                 // Scoop package manager scripts
│   │       ├── nodejs.bat
│   │       ├── golang.bat
│   │       └── python.bat
│   ├── macos/
│   │   ├── brew/                  // Homebrew package manager scripts
│   │   │   ├── nodejs.sh
│   │   │   ├── golang.sh
│   │   │   └── python.sh
│   │   └── native/                // macOS native scripts without package manager
│   │       ├── xcode-cli.sh
│   │       └── other_script.sh
├── go.mod
└── go.sum
