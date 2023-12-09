import sys


def predict_next(seq: list[int]) -> int:
    seqs = [seq]

    while any(x != 0 for x in seq):
        seq = [seq[i + 1] - seq[i] for i in range(len(seq) - 1)]
        seqs.append(seq)

    return sum(seq[-1] for seq in seqs)


def main():
    lines = open(sys.argv[1], "r").read().splitlines()

    part_1 = part_2 = 0
    for line in lines:
        seq = list(map(int, line.split(" ")))

        part_1 += predict_next(seq)
        part_2 += predict_next(list(reversed(seq)))

    print(f"Part 1: {part_1}")
    print(f"Part 2: {part_2}")


if __name__ == "__main__":
    main()
