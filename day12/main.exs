defmodule Day12 do
  defp read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n")
  end

  def part_1(file_path) do
    read_file(file_path) |> parse_records() |> Enum.map(&count_arrangements/1) |> Enum.sum()
  end

  defp parse_records(records) do
    Enum.map(records, fn record ->
      [springs, stats] = String.split(record, " ")

      stats = stats |> String.split(",") |> Enum.map(&String.to_integer/1)

      spring_info =
        springs
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce({[], []}, fn {char, index}, acc ->
          {damaged, working} = acc

          damaged = if char == "#", do: [index | damaged], else: damaged
          working = if char == ".", do: [index | working], else: working

          {damaged, working}
        end)

      {spring_info, String.length(springs), stats}
    end)
  end

  defp count_arrangements({spring_info, len, stats}) do
    {damaged, working} = spring_info
    known_idx = damaged ++ working

    0..(len - 1)
    |> Enum.filter(&(not Enum.member?(known_idx, &1)))
    |> comb(Enum.sum(stats) - length(damaged))
    |> Stream.map(&(&1 ++ damaged))
    |> Enum.filter(&valid_line(&1, stats))
    |> length()
  end

  def comb(_, 0), do: [[]]

  def comb([], _), do: []

  def comb([h | t], m) do
    for(l <- comb(t, m - 1), do: [h | l]) ++ comb(t, m)
  end

  defp valid_line(combination, stats) do
    # IO.puts("validating")

    line_stats =
      combination
      |> Enum.sort()
      # |> IO.inspect()
      |> permutation_stats()

    # IO.puts("stats:")
    # IO.inspect(stats)
    # IO.puts("line_stats:")
    # IO.inspect(line_stats)
    # IO.puts("validated")

    line_stats == stats
  end

  defp permutation_stats(combination) do
    (Enum.sort(combination) ++ [-42])
    |> Enum.reduce({[], nil, 0}, fn idx, {cont, prev, count} ->
      # IO.puts("idx #{idx} prev #{prev} count #{count}")
      # IO.inspect(cont)

      case prev do
        nil ->
          {cont, idx, count + 1}

        prev when prev + 1 != idx ->
          {[count | cont], idx, 1}

        _ ->
          {cont, idx, count + 1}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end
end

# Day12.part_1("input_test.txt") |> IO.puts()
Day12.part_1("input.txt") |> IO.puts()
