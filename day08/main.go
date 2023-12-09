package main

import (
	"fmt"
	"main/utils"
	"regexp"
	"strings"
)

// greatest common divisor (GCD) via Euclidean algorithm
func GCD(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

// find Least Common Multiple (LCM) via GCD
func LCM(a, b int, integers ...int) int {
	result := a * b / GCD(a, b)

	for i := 0; i < len(integers); i++ {
		result = LCM(result, integers[i])
	}

	return result
}

func stepsToFinish(current string, tree map[string][2]string, directions string) int {
	steps := 0
	var dir byte
	for current[len(current)-1] != 'Z' {
		dir = directions[steps%len(directions)]
		if dir == 'L' {
			current = tree[current][0]
		} else {
			current = tree[current][1]
		}
		steps++
	}
	return steps
}

func main() {
	lines := utils.ReadFileLines("input.txt")

	directions := lines[0]
	mappings := lines[2:]

	tree := make(map[string][2]string, len(mappings))
	re := regexp.MustCompile(`([A-Z0-9]+) = \(([A-Z0-9]+), ([A-Z0-9]+)\)`)
	for i := 0; i < len(mappings); i++ {
		matches := re.FindAllStringSubmatch(mappings[i], -1)[0]
		tree[matches[1]] = [2]string{matches[2], matches[3]}
	}

	currents := make([]string, 0)
	var key string
	for i := 0; i < len(mappings); i++ {
		key = strings.Split(mappings[i], " = ")[0]
		if key[len(key)-1] == 'A' {
			currents = append(currents, key)
		}
	}

	all_steps := make([]int, len(currents))
	var steps int
	for i, current := range currents {
		steps = stepsToFinish(current, tree, directions)
		all_steps[i] = steps
	}

	fmt.Println(all_steps)
	for i, curr := range currents {
		if curr == "AAA" {
			fmt.Printf("Part 1: %d\n", all_steps[i])
		}
	}

	total_steps := LCM(all_steps[0], all_steps[1], all_steps[2:]...)
	fmt.Printf("Part 2: %d\n", total_steps)
}
