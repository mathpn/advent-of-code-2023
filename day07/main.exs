defmodule Day07 do
  @card_values %{
    "A" => 1,
    "K" => 2,
    "Q" => 3,
    "J" => 4,
    "T" => 5,
    "9" => 6,
    "8" => 7,
    "7" => 8,
    "6" => 9,
    "5" => 10,
    "4" => 11,
    "3" => 12,
    "2" => 13
  }

  def read_file(file_path) do
    File.read!(file_path) |> String.trim() |> String.split("\n")
  end

  def part_1(file_path) do
    read_file(file_path)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [hand, bid] -> {hand, String.to_integer(bid)} end)
    |> Enum.sort(fn {hand_1, _}, {hand_2, _} ->
      compare_hands(hand_1, hand_2, &count_cards_part_1/1, @card_values)
    end)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, bid}, i}, acc -> acc + bid * i end)
  end

  def part_2(file_path) do
    read_file(file_path)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [hand, bid] -> {hand, String.to_integer(bid)} end)
    |> Enum.sort(fn {hand_1, _}, {hand_2, _} ->
      compare_hands(
        hand_1,
        hand_2,
        &count_cards_part_2/1,
        Map.update(@card_values, "J", 0, &(&1 + 20))
      )
    end)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, bid}, i}, acc -> acc + bid * i end)
  end

  defp compare_hands(hand_1, hand_2, counter_fn, card_values) do
    h1_strength = counter_fn.(hand_1) |> hand_strength()
    h2_strength = counter_fn.(hand_2) |> hand_strength()

    cond do
      h1_strength == h2_strength ->
        compare_cards(hand_1, hand_2, card_values)

      true ->
        h1_strength > h2_strength
    end
  end

  defp hand_strength(card_count) do
    case card_count do
      [5 | _] -> 1
      [4 | _] -> 2
      [3, 2 | _] -> 3
      [3 | _] -> 4
      [2, 2 | _] -> 5
      [2 | _] -> 6
      _ -> 7
    end
  end

  defp count_cards(hand) do
    card_count =
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.reduce(%{:count => [], :joker => 0}, fn {char, count}, acc ->
        case char do
          "J" -> Map.update(acc, :joker, 0, &(&1 + count))
          _ -> Map.update(acc, :count, [], &[count | &1])
        end
      end)
  end

  defp count_cards_part_1(hand) do
    %{:count => count, :joker => joker_count} = count_cards(hand)
    Enum.sort([joker_count | count], &(&1 >= &2))
  end

  defp count_cards_part_2(hand) do
    %{:count => count, :joker => joker_count} = count_cards(hand)
    count = Enum.sort(count, &(&1 >= &2))

    case count do
      [] -> [joker_count]
      [highest_count | rest] -> [highest_count + joker_count | rest]
    end
  end

  defp compare_cards(hand_1, hand_2, card_values) do
    Enum.zip(hand_1 |> String.graphemes(), hand_2 |> String.graphemes())
    |> Enum.reduce_while(false, fn {char_1, char_2}, acc ->
      ch1_value = Map.get(card_values, char_1, 0)
      ch2_value = Map.get(card_values, char_2, 0)
      if ch1_value == ch2_value, do: {:cont, false}, else: {:halt, ch1_value > ch2_value}
    end)
  end
end

# Day07.part_1("input_test.txt") |> IO.puts()
# Day07.part_2("input_test.txt") |> IO.puts()
Day07.part_1("input.txt") |> IO.puts()
Day07.part_2("input.txt") |> IO.puts()
