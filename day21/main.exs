defmodule Day21 do
  defp read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n")
  end

  def part_1(file_path) do
    starts = read_file(file_path) |> find_start()

    read_file(file_path)
    |> parse_input()
    |> walk(starts, 0)
    |> Enum.sort()
    |> IO.inspect()
    |> length()
  end

  defp walk(_, starts, 64), do: starts

  defp walk(garden_plots, starts, steps) do
    starts =
      starts
      |> Enum.flat_map(&possible_steps/1)
      |> Enum.filter(&(&1 in garden_plots))
      |> Enum.uniq()

    walk(garden_plots, starts, steps + 1)
  end

  defp possible_steps({row, col}) do
    [
      {row, col + 1},
      {row + 1, col},
      {row, col - 1},
      {row - 1, col}
    ]
  end

  defp find_start(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {line, row} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        case char do
          "S" -> {row, col}
          _ -> nil
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
  end

  defp parse_input(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {line, row} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, col} ->
        case char do
          "." -> {row, col}
          "S" -> {row, col}
          _ -> nil
        end
      end)
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
    |> MapSet.new()
  end
end

Day21.part_1("input_test.txt") |> IO.puts()
Day21.part_1("input.txt") |> IO.puts()
