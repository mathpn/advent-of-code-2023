import re
from collections import defaultdict


def find_neighbors(grid: list[str], row: int, start: int, end: int):
    neighbors = []

    for v in (row - 1, row, row + 1):
        for h in range(start - 1, end + 1):
            if v >= len(grid) or v < 0:
                continue
            if h >= len(grid[0]) or h < 0:
                continue

            char = grid[v][h]
            if char not in "0123456789.":
                neighbors.append((char, v, h))

    return neighbors


def main():
    grid = open("input.txt", "r").read().splitlines()

    total = 0
    neighbors = defaultdict(list)
    for i, row in enumerate(grid):
        for n in re.finditer(r"\d+", row):
            n_neighbors = find_neighbors(grid, i, n.start(), n.end())
            number = int(n.group())

            if n_neighbors:
                total += number

            for neighbor in n_neighbors:
                neighbors[neighbor].append(number)

    sum_gear_ratio = sum(
        v[0] * v[1]
        for (char, _, _), v in neighbors.items()
        if char == "*" and len(v) == 2
    )

    print(f"Part 1: {total}")
    print(f"Part 2: {sum_gear_ratio}")


if __name__ == "__main__":
    main()
