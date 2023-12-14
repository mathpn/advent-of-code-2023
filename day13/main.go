package main

import (
	"fmt"
	"os"
	"strings"
)

func readFile(file_path string) []string {
	f, err := os.ReadFile(file_path)
	if err != nil {
		panic(err)
	}
	patterns := strings.Split(strings.TrimSpace(string(f)), "\n\n")
	return patterns
}

func rotatePattern(pattern []string) []string {
	out := make([]string, len(pattern[0]))
	for i := 0; i < len(pattern[0]); i++ {
		var line []byte
		for j := 0; j < len(pattern); j++ {
			line = append(line, pattern[j][i])
		}
		out[i] = string(line)
	}
	return out
}

func stringDiff(a, b string) int {
	diff := 0
	for i := 0; i < len(a); i++ {
		if a[i] != b[i] {
			diff++
		}
	}
	return diff
}

func ReflectionSmudgeIndex(lines []string, smudges int) int {
	var reflect_idx, diff int

	for i := 0; i < len(lines)-1; i++ {
		diff = 0

		for j := 1; j < len(lines)-i; j++ {
			reflect_idx = i - j + 1

			if reflect_idx < 0 {
				break
			}

			diff += stringDiff(lines[i+j], lines[reflect_idx])
		}

		if diff == smudges {
			return i + 1
		}

	}
	return 0
}

func main() {
	patterns := readFile("input.txt")

	var part_1, part_2 int
	for _, pattern := range patterns {
		lines := strings.Split(pattern, "\n")
		h_idx := ReflectionSmudgeIndex(lines, 0)
		v_idx := ReflectionSmudgeIndex(rotatePattern(lines), 0)
		part_1 += v_idx + 100*h_idx

		h_idx = ReflectionSmudgeIndex(lines, 1)
		v_idx = ReflectionSmudgeIndex(rotatePattern(lines), 1)
		part_2 += v_idx + 100*h_idx
	}
	fmt.Printf("Part 1: %d\n", part_1)
	fmt.Printf("Part 2: %d\n", part_2)
}
