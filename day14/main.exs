defmodule Day14 do
  defp read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n")
  end

  def part_1(file_path) do
    read_file(file_path)
    |> parse_platform()
    |> tilt_north()
    |> platform_load()
  end

  defp parse_platform(platform) do
    Enum.with_index(platform)
    |> Enum.reduce({[], []}, fn {line, row_idx}, acc ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col_idx}, {rounded, cube} ->
        rounded = if char == "O", do: [{row_idx, col_idx} | rounded], else: rounded
        cube = if char == "#", do: [{row_idx, col_idx} | cube], else: cube

        {rounded, cube}
      end)
    end)
  end

  defp map_cube_rocks(cube_positions) do
    row_map =
      Enum.reduce(cube_positions, %{}, fn {row_idx, col_idx}, acc ->
        Map.update(acc, row_idx, [col_idx], &[col_idx | &1])
      end)

    col_map =
      Enum.reduce(cube_positions, %{}, fn {row_idx, col_idx}, acc ->
        Map.update(acc, col_idx, [row_idx], &[row_idx | &1])
      end)

    {row_map, col_map}
  end

  defp platform_load({rounded, cube}) do
    height = Enum.map(cube, fn {row_idx, _} -> row_idx end) |> Enum.max()

    Enum.map(rounded, fn {row_idx, _} ->
      height - row_idx + 1
    end)
    |> Enum.sum()
  end

  defp tilt_north({rounded, cube}) do
    {_, col_map} = map_cube_rocks(cube)

    rounded =
      Enum.sort(rounded, fn {a, _}, {b, _} -> a < b end)
      |> tilt([], col_map)

    {rounded, cube}
  end

  defp tilt([], tilted_rounded, _col_map), do: tilted_rounded

  defp tilt([{row_idx, col_idx} | tail], tilted_rounded, col_map) do
    {row_idx, col_idx} = move_rock(row_idx, col_idx, Map.get(col_map, col_idx, []))

    col_map = Map.update(col_map, col_idx, [row_idx], &[row_idx | &1])

    tilt(tail, [{row_idx, col_idx} | tilted_rounded], col_map)
  end

  defp move_rock(_, col_idx, []), do: {0, col_idx}

  defp move_rock(row_idx, col_idx, cube_rows) do
    case Enum.filter(cube_rows, &(&1 < row_idx)) do
      [] ->
        {0, col_idx}

      cube_rows ->
        {Enum.max(cube_rows) + 1, col_idx}
    end
  end
end

Day14.part_1("input.txt") |> IO.puts()
