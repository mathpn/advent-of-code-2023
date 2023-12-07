package main

import (
	"fmt"
	"main/utils"
	"strconv"
	"strings"
)

func main() {
	lines := utils.ReadFileLines("input.txt")

	// part 1
	times := strings.Fields(strings.Split(lines[0], ":")[1])
	records := strings.Fields(strings.Split(lines[1], ":")[1])

	part_1 := 1
	var ways int
	for i := 0; i < len(times); i++ {
		time, _ := strconv.Atoi(times[i])
		record, _ := strconv.Atoi(records[i])

		ways = 0
		for j := 0; j < time; j++ {
			if time*j-j*j > record {
				ways++
			}
		}

		part_1 *= ways
	}

	// part 2
	time, _ := strconv.Atoi(strings.Join(times, ""))
	record, _ := strconv.Atoi(strings.Join(records, ""))

	ways = 0
	for j := 0; j < time; j++ {
		if time*j-j*j > record {
			ways++
		}
	}

	fmt.Printf("Part 1: %d\n", part_1)
	fmt.Printf("Part 2: %d\n", ways)
}
