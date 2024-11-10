// pkg/osinfo/osinfo.go
package osinfo

import (
	"runtime"
)

type OSInfo struct {
	Name string
}

func GetOSInfo() OSInfo {
	os := runtime.GOOS
	return OSInfo{Name: os}
}

func GetPackageManager(osInfo OSInfo) string {
	switch osInfo.Name {
	case "darwin":
		return "brew"
	case "linux":
		// Check specific distro if necessary
		return "apt" // Default to apt; modify if supporting more distros
	default:
		return ""
	}
}
