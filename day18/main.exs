defmodule Day18 do
  defp read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n")
  end

  def part_1(file_path) do
    file_path |> read_file() |> parse_dig_plan() |> build_polygon_p1() |> area() |> trunc()
  end

  def part_2(file_path) do
    file_path |> read_file() |> parse_dig_plan() |> build_polygon_p2() |> area() |> trunc()
  end

  defp parse_dig_plan(lines) do
    lines
    |> Enum.map(fn line ->
      [_, dir, steps, colour] = Regex.run(~r/(\w) (\d+) \((#\w{6})\)/, line)
      {String.to_atom(dir), String.to_integer(steps), colour}
    end)
  end

  defp build_polygon_p2(instructions) do
    instructions
    |> Enum.map(fn
      {_, _, <<"#", steps::binary-size(5), dir::binary-size(1)>>} ->
        {String.to_integer(dir), String.to_integer(steps, 16)}
    end)
    |> Enum.scan({0, 0}, fn
      {0, c}, {x, y} -> {x + c, y}
      {1, c}, {x, y} -> {x, y + c}
      {2, c}, {x, y} -> {x - c, y}
      {3, c}, {x, y} -> {x, y - c}
    end)
  end

  defp build_polygon_p1(instructions) do
    instructions
    |> Enum.scan({0, 0}, fn
      {:U, c, _}, {x, y} -> {x, y - c}
      {:D, c, _}, {x, y} -> {x, y + c}
      {:L, c, _}, {x, y} -> {x - c, y}
      {:R, c, _}, {x, y} -> {x + c, y}
    end)
  end

  defp length_boundary(polygon) do
    polygon
    |> Enum.chunk_every(2, 1, polygon)
    |> Enum.map(fn [{xi, yi}, {xj, yj}] -> abs(xj - xi) + abs(yj - yi) end)
    |> Enum.sum()
  end

  defp polygon_area(polygon) do
    polygon
    |> Enum.chunk_every(2, 1, polygon)
    |> Enum.map(&trapezoid_area/1)
    |> Enum.sum()
  end

  defp area(polygon) do
    l_boundary = length_boundary(polygon)
    polygon_area(polygon) |> inside_tiles(l_boundary) |> then(&(&1 + l_boundary))
  end

  defp trapezoid_area([{xi, yi}, {xj, yj}]), do: (yi + yj) * (xi - xj) / 2

  defp inside_tiles(area, n_vertices), do: 1 + abs(area) - n_vertices / 2
end

Day18.part_1("input.txt") |> IO.puts()
Day18.part_2("input.txt") |> IO.puts()
