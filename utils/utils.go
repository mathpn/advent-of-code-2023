package utils

import (
	"os"
	"strings"
)

func ReadFileLines(file string) []string {
	f, err := os.ReadFile(file)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(strings.TrimSpace(string(f)), "\n")
	return lines
}
