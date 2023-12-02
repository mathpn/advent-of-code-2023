package main

import (
	"fmt"
	"main/utils"
	"strconv"
	"strings"
)

func extractNumbers(line string) string {
	line = strings.ReplaceAll(line, "one", "o1e")
	line = strings.ReplaceAll(line, "two", "t2o")
	line = strings.ReplaceAll(line, "three", "t3e")
	line = strings.ReplaceAll(line, "four", "f4r")
	line = strings.ReplaceAll(line, "five", "f5e")
	line = strings.ReplaceAll(line, "six", "s6x")
	line = strings.ReplaceAll(line, "seven", "s7n")
	line = strings.ReplaceAll(line, "eight", "e8t")
	line = strings.ReplaceAll(line, "nine", "n9e")
	return line
}

func extractCalibrationNumber(line string) int {
	var b byte
	var digits []byte
	for i := 0; i < len(line); i++ {
		b = line[i]
		if b < '0' || b > '9' {
			continue
		}
		digits = append(digits, b)
	}
	number, err := strconv.Atoi(string(digits[0]) + string(digits[len(digits)-1]))
	if err != nil {
		panic(err)
	}
	return number
}

func main() {
	lines := utils.ReadFileLines("input.txt")

	var number int
	// part 1
	sum := 0
	for _, line := range lines {
		number = extractCalibrationNumber(line)
		sum += number
	}
	fmt.Printf("Part 1: the sum of all calibration values is %d\n", sum)

	// part 2
	sum = 0
	for _, line := range lines {
		line = extractNumbers(line)
		number = extractCalibrationNumber(line)
		sum += number
	}
	fmt.Printf("Part 2: the sum of all calibration values is %d\n", sum)
}
