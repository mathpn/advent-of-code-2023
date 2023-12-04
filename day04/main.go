package main

import (
	"fmt"
	"main/utils"
	"strconv"
	"strings"
)

func mapFromSlice(slice []string) map[string]bool {
	out := make(map[string]bool, len(slice))
	for _, elem := range slice {
		out[elem] = true
	}
	return out
}

func mapOverlap(map1 map[string]bool, map2 map[string]bool) int {
	overlap := 0
	for elem := range map1 {
		_, ok := map2[elem]
		if ok {
			overlap++
		}
	}
	return overlap
}

func calcPoints(overlap int) int {
	points := 0

	if overlap > 0 {
		points = 1
	}

	for i := 0; i < overlap-1; i++ {
		points *= 2
	}

	return points
}

func main() {
	lines := utils.ReadFileLines("input.txt")

	points := 0
	number_cards := make(map[int]int, 0)

	for _, card := range lines {
		split_line := strings.Split(card, ":")
		game, _ := strconv.Atoi(strings.Fields(split_line[0])[1])
		split_line = strings.Split(split_line[1], "|")
		winning := mapFromSlice(strings.Fields(strings.TrimSpace(split_line[0])))
		mine := mapFromSlice(strings.Fields(strings.TrimSpace(split_line[1])))
		overlap := mapOverlap(winning, mine)
		points += calcPoints(overlap)

		number_cards[game] += 1
		for i := 0; i < overlap; i++ {
			number_cards[game+i+1] += number_cards[game]
		}
	}

	total_cards := 0
	for _, n := range number_cards {
		total_cards += n
	}

	fmt.Println(points)
	fmt.Println(total_cards)
}
