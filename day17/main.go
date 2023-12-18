package main

import (
	"container/heap"
	"fmt"
	"strconv"

	"main/utils"
)

func parseMap(lines []string) [][]int {
	out := make([][]int, 0)

	var number int
	for i := 0; i < len(lines); i++ {
		var num_line []int
		for j := 0; j < len(lines[i]); j++ {
			number, _ = strconv.Atoi(lines[i][j : j+1])
			num_line = append(num_line, number)
		}
		out = append(out, num_line)
	}
	return out
}

type direction [2]int

var (
	up    = direction{0, -1}
	down  = direction{0, 1}
	right = direction{1, 0}
	left  = direction{-1, 0}
)

var directions = [4]direction{up, down, right, left}

type coord struct {
	x int
	y int
}

type vertex struct {
	coord     coord
	streak    int
	direction direction
}

type node struct {
	vertex *vertex
	dist   int
}

type DistHeap []node

func (h DistHeap) Len() int           { return len(h) }
func (h DistHeap) Less(i, j int) bool { return h[i].dist < h[j].dist }
func (h DistHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *DistHeap) Push(x any) {
	// Push and Pop use pointer receivers because they modify the slice's length,
	// not just its contents.
	*h = append(*h, x.(node))
}

func (h *DistHeap) Pop() any {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

func getNeighbors(v *vertex, lo, hi, max_x, max_y int) (ret []*vertex) {
	var new_v *vertex
	for _, dir := range directions {
		streak := v.streak + 1

		if dir[0] == -1*v.direction[0] && dir[1] == -1*v.direction[1] {
			continue
		}

		if streak < lo && dir != v.direction {
			continue
		}

		if streak >= hi || dir != v.direction {
			streak = 0
			if dir == v.direction {
				continue
			}
		}

		new_v = &vertex{coord{v.coord.x + dir[0], v.coord.y + dir[1]}, streak, dir}
		if invalidNeighbor(new_v, max_x, max_y) {
			continue
		}

		ret = append(ret, new_v)
	}
	return ret
}

func invalidNeighbor(v *vertex, max_x int, max_y int) bool {
	return v.coord.x < 0 || v.coord.y < 0 || v.coord.x > max_x || v.coord.y > max_y
}

func dijkstra(grid [][]int, src vertex, dst coord, neighbor_func func(*vertex) []*vertex) int {
	dist := make(map[vertex]int, len(grid)*len(grid[0]))

	h := &DistHeap{}
	heap.Init(h)
	heap.Push(h, node{dist: 0, vertex: &src})

	var d, new_d int
	var nn []*vertex
	var target *vertex
	for h.Len() > 0 {
		curr := heap.Pop(h).(node)

		if curr.vertex.coord == dst {
			target = curr.vertex
			break
		}

		nn = neighbor_func(curr.vertex)
		for _, n := range nn {
			new_d = curr.dist + grid[n.coord.y][n.coord.x]
			d = dist[*n]
			if d == 0 || new_d < d {
				dist[*n] = new_d
				heap.Push(h, node{dist: new_d, vertex: n})
			}
		}
	}

	d = dist[*target]
	if d == 0 {
		return 1 << 16
	}
	return d
}

func main() {
	lines := utils.ReadFileLines("input.txt")
	grid := parseMap(lines)

	max_coord := coord{len(lines[0]) - 1, len(lines) - 1}

	part_1 := 1 << 16
	part_2 := 1 << 16

	var d int
	for _, dir := range [2]direction{right, down} {
		d = dijkstra(
			grid,
			vertex{coord{0, 0}, 0, dir},
			max_coord,
			func(v *vertex) []*vertex { return getNeighbors(v, 1, 3, max_coord.x, max_coord.y) },
		)
		part_1 = min(part_1, d)

		d = dijkstra(
			grid,
			vertex{coord{0, 0}, 0, dir},
			max_coord,
			func(v *vertex) []*vertex { return getNeighbors(v, 4, 10, max_coord.x, max_coord.y) },
		)
		part_2 = min(part_2, d)
	}

	fmt.Println(part_1)
	fmt.Println(part_2)
}
