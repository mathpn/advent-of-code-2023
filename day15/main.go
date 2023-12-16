package main

import (
	"fmt"
	"main/utils"
	"strconv"
	"strings"
)

type lens struct {
	label string
	focal int
}

func hash(str string) int {
	out := 0
	for i := 0; i < len(str); i++ {
		out += int(str[i])
		out *= 17
		out = out % 256
	}
	return out
}

func focusingPower(box map[int][]lens) int {
	power := 0
	for box, lenses := range box {
		for i := 0; i < len(lenses); i++ {
			power += (1 + box) * (1 + i) * lenses[i].focal
		}
	}
	return power
}

func fillBoxes(seq string, boxes map[int][]lens) map[int][]lens {
	label := strings.Split(seq, "=")[0]
	label_hash := hash(label)
	focal, _ := strconv.Atoi(strings.Split(seq, "=")[1])

	new_lens := lens{label, focal}
	box_lenses := boxes[label_hash]

	found := false
	for i := 0; i < len(box_lenses); i++ {
		if box_lenses[i].label == new_lens.label {
			found = true
			box_lenses[i].focal = new_lens.focal
			break
		}
	}

	if !found {
		box_lenses = append(box_lenses, new_lens)
	}

	boxes[label_hash] = box_lenses
	return boxes
}

func removeFromBoxes(seq string, boxes map[int][]lens) map[int][]lens {
	label := strings.Split(seq, "-")[0]
	label_hash := hash(label)

	box_lenses, ok := boxes[label_hash]

	if !ok {
		boxes[label_hash] = make([]lens, 0)
	}

	filtered_lenses := make([]lens, 0)
	for i := 0; i < len(box_lenses); i++ {
		if box_lenses[i].label != label {
			filtered_lenses = append(filtered_lenses, box_lenses[i])
		}
	}

	boxes[label_hash] = filtered_lenses
	return boxes
}

func updateBoxes(seq string, boxes map[int][]lens) map[int][]lens {
	if strings.Contains(seq, "=") {
		boxes = fillBoxes(seq, boxes)
	} else {
		boxes = removeFromBoxes(seq, boxes)
	}
	return boxes
}

func main() {
	seqs := strings.Split(utils.ReadFileLines("input.txt")[0], ",")

	var seq_hash int
	total := 0

	for _, seq := range seqs {
		seq_hash = hash(seq)
		total += seq_hash
	}

	fmt.Printf("Part 1: %d\n", total)

	box_map := make(map[int][]lens, 256)

	for _, seq := range seqs {
		seq_hash = hash(seq)
		box_map = updateBoxes(seq, box_map)
		total += seq_hash
	}

	power := focusingPower(box_map)
	fmt.Printf("Part 2: %d\n", power)

}
