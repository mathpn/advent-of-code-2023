defmodule Day05 do
  def read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n\n")
  end

  def run(file_path) do
    [seed_line | map_lines] = read_file(file_path)
    part_1_seeds = extract_seeds(seed_line)
    part_2_seeds = extract_range_seeds(seed_line) |> Enum.map(fn {r, l} -> {r, l, false} end)

    maps = Enum.map(map_lines, &parse_map/1)

    Enum.map(part_1_seeds, &traverse(maps, &1))
    |> List.flatten()
    |> Enum.min()
    |> IO.puts()

    traverse_ranges(maps, part_2_seeds)
    |> Enum.map(fn {r_start, _, _} -> r_start end)
    |> Enum.min()
    |> IO.puts()
  end

  defp parse_map(map_line) do
    [_, map_info] = String.split(map_line, ":")

    map_info
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn x ->
      String.split(x, " ") |> Enum.map(&String.to_integer/1)
    end)
  end

  defp extract_seeds("seeds: " <> seeds) do
    String.split(seeds) |> Enum.map(&String.to_integer/1)
  end

  defp extract_range_seeds("seeds: " <> seeds) do
    String.split(seeds)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  defp traverse([], location), do: location

  defp traverse([map | rest], location) do
    location =
      Enum.filter(map, fn [_, source_start, len] ->
        location >= source_start and location < source_start + len
      end)
      |> Enum.reduce(location, fn map_line, location ->
        [dest_start, source_start, len] = map_line

        cond do
          location >= source_start and location < source_start + len ->
            dest_start + location - source_start

          true ->
            location
        end
      end)

    traverse(rest, location)
  end

  defp traverse_ranges([], ranges), do: ranges

  defp traverse_ranges([map | rest], ranges) do
    ranges = Enum.map(ranges, fn {r, l, _} -> {r, l, false} end)

    ranges =
      Enum.reduce(map, ranges, fn [dest_start, source_start, len], ranges ->
        mapped_ranges = Enum.filter(ranges, fn {_, _, mapped} -> mapped end)

        new_ranges =
          Enum.filter(ranges, fn {_, _, mapped} -> not mapped end)
          |> Enum.map(fn {r, l, _} -> split_range({r, l}, {dest_start, source_start, len}) end)
          |> List.flatten()
          |> Enum.filter(fn {_, l, _} -> l > 0 end)

        mapped_ranges ++ new_ranges
      end)
      |> List.flatten()

    traverse_ranges(rest, ranges)
  end

  defp split_range({r_start, r_len}, {dest_start, source_start, len}) do
    cond do
      r_start + r_len < source_start ->
        [{r_start, r_len, false}]

      r_start >= source_start + len ->
        [{r_start, r_len, false}]

      r_start < source_start and r_start + r_len < source_start + len ->
        left_tail = source_start - r_start
        [{r_start, left_tail, false}, {dest_start, r_len - left_tail, true}]

      r_start >= source_start and r_start + r_len <= source_start + len ->
        shift = r_start - source_start
        [{dest_start + shift, r_len, true}]

      r_start < source_start and r_start + r_len == source_start + len ->
        left_tail = source_start - r_start
        [{r_start, left_tail, false}, {dest_start, len, true}]

      r_start < source_start and r_start + r_len > source_start + len ->
        left_tail = source_start - r_start
        right_tail = r_start + r_len - (source_start + len)

        [
          {r_start, left_tail, false},
          {dest_start, len, true},
          {source_start + len, right_tail, false}
        ]

      r_start >= source_start and r_start + r_len > source_start + len ->
        shift = r_start - source_start
        overlap = source_start + len - r_start
        [{dest_start + shift, overlap, true}, {r_start + overlap, r_len - overlap, false}]
    end
  end
end

# Day05.run("input_test.txt")
Day05.run("input.txt")
