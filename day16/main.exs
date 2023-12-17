defmodule Day16 do
  @transitions %{
    :right => %{
      "/" => [:up],
      "\\" => [:down],
      "|" => [:up, :down]
    },
    :left => %{
      "/" => [:down],
      "\\" => [:up],
      "|" => [:up, :down]
    },
    :up => %{
      "/" => [:right],
      "\\" => [:left],
      "-" => [:left, :right]
    },
    :down => %{
      "/" => [:left],
      "\\" => [:right],
      "-" => [:left, :right]
    }
  }

  defp read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n")
  end

  def part_1(file_path) do
    read_file(file_path)
    |> parse_contraption()
    |> trace_beam({:right, {0, 0}})
    |> count_energized()
  end

  def part_2(file_path) do
    read_file(file_path)
    |> parse_contraption()
    |> trace_all_beams()
    |> Enum.map(&count_energized/1)
    |> Enum.max()
  end

  defp count_energized(beam_path) do
    beam_path |> Enum.map(fn {_, pos} -> pos end) |> Enum.uniq() |> length()
  end


  defp parse_contraption(lines) do
    Enum.with_index(lines)
    |> Enum.flat_map(fn {line, row} ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.map(fn {char, col} -> {{row, col}, char} end)
    end)
    |> Map.new()
    |> add_bounds()
  end

  defp add_bounds(grid), do: Map.keys(grid) |> Enum.max() |> Tuple.insert_at(0, grid)

  defp trace_beam(contraption, start), do: trace(MapSet.new([start]), [start], contraption)

  defp trace_all_beams(contraption = {_, max_row, max_col}) do
    find_starts(max_row, max_col)
    |> Task.async_stream(&trace_beam(contraption, &1))
    |> Enum.map(fn {:ok, res} -> res end)
  end

  defp find_starts(max_row, max_col) do
    Enum.concat(
      Enum.flat_map(0..max_row, fn row -> [{:right, {row, 0}}, {:left, {row, max_col}}] end),
      Enum.flat_map(0..max_col, fn col -> [{:up, {max_row, col}}, {:down, {0, col}}] end)
    )
  end

  defp trace(beam_path, beams, contraption = {grid, max_row, max_col}) do
    beams
    |> Enum.flat_map(fn beam = {_, pos} -> move_beam(beam, grid[pos]) end)
    |> Enum.reject(fn {_, {row, col}} -> row < 0 or col < 0 or row > max_row or col > max_col end)
    |> Enum.reject(&(&1 in beam_path))
    |> case do
      [] ->
        beam_path

      beams ->
        beams
        |> Enum.reduce(beam_path, &MapSet.put(&2, &1))
        |> trace(beams, contraption)
    end
  end

  defp move_beam({direction, {row, col}}, mirror) do
    Map.get(@transitions[direction], mirror, [direction])
    |> Enum.map(fn dir ->
      case dir do
        :left -> {dir, {row, col - 1}}
        :right -> {dir, {row, col + 1}}
        :up -> {dir, {row - 1, col}}
        :down -> {dir, {row + 1, col}}
      end
    end)
  end
end

Day16.part_1("input.txt") |> IO.puts()
Day16.part_2("input.txt") |> IO.puts()
