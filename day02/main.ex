defmodule Day02 do
  @max_red 12
  @max_green 13
  @max_blue 14

  def read_file(file) do
    File.read!(file) |> String.trim() |> String.split("\n")
  end

  def parse_line("Game " <> line) do
    {id, rest} = Integer.parse(line)

    ": " <> results = rest

    %{
      :id => id,
      :results => String.split(results, ";") |> Enum.map(&parse_result/1)
    }
  end

  defp parse_result(result) do
    result
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn result ->
      case Integer.parse(result) do
        {count, " red"} -> {:red, count}
        {count, " green"} -> {:green, count}
        {count, " blue"} -> {:blue, count}
      end
    end)
    |> Enum.into(%{})
  end

  def part_1(input) do
    sum =
      Enum.map(input, &parse_line/1)
      |> Enum.filter(&result_valid?/1)
      |> Enum.reduce(0, fn %{:id => id}, acc -> acc + id end)

    IO.puts("Part 1: #{sum}")
  end

  def part_2(input) do
    sum_power =
      Enum.map(input, &parse_line/1)
      |> Enum.map(fn %{:results => results} -> min_set(results) end)
      |> Enum.map(&calc_power/1)
      |> Enum.sum()

    IO.puts("Part 2: #{sum_power}")
  end

  defp result_valid?(result) do
    %{:results => results} = result

    results
    |> Enum.all?(fn draw ->
      case draw do
        %{:red => count} when count > @max_red -> false
        %{:green => count} when count > @max_green -> false
        %{:blue => count} when count > @max_blue -> false
        _ -> true
      end
    end)
  end

  defp min_set(result) do
    %{
      :red => result |> Enum.map(fn x -> Map.get(x, :red, 0) end) |> Enum.max(),
      :green => result |> Enum.map(fn x -> Map.get(x, :green, 0) end) |> Enum.max(),
      :blue => result |> Enum.map(fn x -> Map.get(x, :blue, 0) end) |> Enum.max()
    }
  end

  defp calc_power(set) do
    set |> Map.values() |> Enum.reduce(1, fn x, acc -> x * acc end)
  end
end

Day02.read_file("input.txt") |> Day02.part_1()
Day02.read_file("input.txt") |> Day02.part_2()
