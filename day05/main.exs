defmodule Day05 do
  def read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n\n")
  end

  def run(file_path) do
    [seed_line | map_lines] = read_file(file_path)
    part_1_seeds = extract_seeds(seed_line)
    part_2_seeds = extract_range_seeds(seed_line)

    maps = Enum.map(map_lines, &parse_map/1)

    Enum.map(part_1_seeds, &traverse(maps, &1)) |> Enum.min() |> IO.puts()
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
end

# Day05.run("input_test.txt")
Day05.run("input.txt")
