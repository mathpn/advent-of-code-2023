package main

import (
	"fmt"
	"main/utils"
	"sort"
)

type position struct {
	x int
	y int
}

func expand(galaxies []position, factor int, getter func(position) int, update func(position, int) position) []position {
	out := make([]position, len(galaxies))
	copy(out, galaxies)

	sort.Slice(out, func(i, j int) bool { return getter(out[i]) < getter(out[j]) })

	expansions := 0
	prev := -1
	var diff int
	for i, galaxy := range out {
		diff = getter(galaxy) - prev
		if getter(galaxy) != prev && diff != 1 {
			expansions += (factor - 1) * (diff - 1)
		}
		prev = getter(galaxy)
		galaxy = update(galaxy, prev+expansions)
		out[i] = galaxy
	}

	return out
}

func abs(a int) int {
	if a < 0 {
		a *= -1
	}
	return a
}

func pairwiseDistance(galaxies []position) []int {
	var dist int
	dists := make([]int, 0)
	for i := 0; i < len(galaxies); i++ {
		for j := i + 1; j < len(galaxies); j++ {
			dist = abs(galaxies[i].x-galaxies[j].x) + abs(galaxies[i].y-galaxies[j].y)
			dists = append(dists, dist)
		}
	}
	return dists
}

func sumShortestDistances(galaxies []position, factor int) int {
	galaxies = expand(
		galaxies,
		factor,
		func(p position) int { return p.x },
		func(p position, i int) position { return position{i, p.y} },
	)

	galaxies = expand(
		galaxies,
		factor,
		func(p position) int { return p.y },
		func(p position, i int) position { return position{p.x, i} },
	)

	dists := pairwiseDistance(galaxies)

	sum_dist := 0
	for i := 0; i < len(dists); i++ {
		sum_dist += dists[i]
	}

	return sum_dist
}

func main() {
	lines := utils.ReadFileLines("input.txt")

	galaxies := make([]position, 0)

	for x, line := range lines {
		for y, char := range line {
			if char == '#' {
				galaxies = append(galaxies, position{x, y})
			}
		}
	}

	var sum_dist int

	sum_dist = sumShortestDistances(galaxies, 2)
	fmt.Println(sum_dist)

	sum_dist = sumShortestDistances(galaxies, 1_000_000)
	fmt.Println(sum_dist)
}
