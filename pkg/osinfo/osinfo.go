// pkg/osinfo/osinfo.go
package osinfo

import (
	"runtime"
)

type OSInfo struct {
	OS             string
	PackageManager string
}

func GetOSInfo() OSInfo {
	os := runtime.GOOS
	return OSInfo{
		OS:             os,
		PackageManager: GetPackageManager(os),
	}
}

func GetPackageManager(osInfo string) string {

	if osInfo == "darwin" {
		return "brew"
	}
	if osInfo == "linux" {
		return "apt"
	}
	return ""
}
