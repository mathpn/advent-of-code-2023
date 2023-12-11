defmodule Day10 do
  @fsm %{
    :check_left => %{
      "-" => :check_left,
      "L" => :check_top,
      "F" => :check_bottom,
      "S" => :end,
      :default => :stop
    },
    :check_right => %{
      "-" => :check_right,
      "J" => :check_top,
      "7" => :check_bottom,
      "S" => :end,
      :default => :stop
    },
    :check_top => %{
      "|" => :check_top,
      "7" => :check_left,
      "F" => :check_right,
      "S" => :end,
      :default => :stop
    },
    :check_bottom => %{
      "|" => :check_bottom,
      "L" => :check_right,
      "J" => :check_left,
      "S" => :end,
      :default => :stop
    }
  }

  defp read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n") |> Enum.map(&String.graphemes/1)
  end

  def part_1(file_path) do
    read_file(file_path) |> walk_pipes() |> shortest_path() |> Map.values() |> Enum.max()
  end

  defp shortest_path(paths) do
    paths
    |> Enum.reduce(%{}, fn path, acc ->
      Enum.reduce(path, acc, fn {pos, count}, acc ->
        Map.update(acc, pos, count, &Enum.min([&1, count]))
      end)
    end)
  end

  defp find_start(pipes) do
    pipes
    |> Enum.with_index()
    |> Enum.map(fn {line, idx} ->
      {idx, Enum.find_index(line, &(&1 == "S"))}
    end)
    |> Enum.filter(fn {_, idx} -> idx != nil end)
    |> Enum.at(0)
  end

  defp walk_pipes(pipes) do
    position = find_start(pipes)

    Enum.map(
      [:check_left, :check_right, :check_top, :check_bottom],
      &walk(pipes, position, [], -1, &1)
    )
  end

  defp walk(_pipes, _position, _path, _steps, :stop), do: []

  defp walk(_pipes, _position, path, _steps, :end), do: path

  defp walk(pipes, {row, col}, path, steps, state) do
    path = [{{row, col}, steps + 1} | path]

    position =
      case state do
        :check_left -> {row, col - 1}
        :check_right -> {row, col + 1}
        :check_top -> {row - 1, col}
        :check_bottom -> {row + 1, col}
      end

    state = Map.get(@fsm, state, %{}) |> Map.get(get_char(pipes, position), :stop)
    walk(pipes, position, path, steps + 1, state)
  end

  defp get_char(_pipes, {row, col}) when row < 0 or col < 0, do: "."

  defp get_char(pipes, {row, col}) do
    Enum.at(pipes, row, []) |> Enum.at(col, ".")
  end
end

Day10.part_1("input.txt") |> IO.puts()
