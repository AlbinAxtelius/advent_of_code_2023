defmodule AdventOfCode.Solutions.Day7.Part1 do
  @moduledoc false

  @test_data """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483\
  """

  @card_power [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "T",
    "J",
    "Q",
    "K",
    "A"
  ]

  @hand_power [
    :high_card,
    :pair,
    :two_pairs,
    :three_of_a_kind,
    :full_house,
    :four_of_a_kind,
    :five_of_a_kind
  ]

  @spec get_kind(String.t()) :: atom()
  def get_kind(hand) do
    occurrences =
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.values()

    case Enum.sort(occurrences, :desc) do
      [5] -> :five_of_a_kind
      [4 | _] -> :four_of_a_kind
      [3, 2] -> :full_house
      [3 | _] -> :three_of_a_kind
      [2, 2 | _] -> :two_pairs
      [2 | _] -> :pair
      [1 | _] -> :high_card
    end
  end

  def is_hand_greater?([head_a | rest_a], [head_b | rest_b])
      when head_a == head_b,
      do: is_hand_greater?(rest_a, rest_b)

  def is_hand_greater?([head_a | _], [head_b | _]) do
    Enum.find_index(@card_power, fn x -> x == head_a end) >
      Enum.find_index(@card_power, fn x -> x == head_b end)
  end

  def is_kind_greater?(kind_a, kind_b) when kind_a == kind_b, do: true

  def is_kind_greater?(kind_a, kind_b) do
    Enum.find_index(@hand_power, fn x -> x == kind_a end) >
      Enum.find_index(@hand_power, fn x -> x == kind_b end)
  end

  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [hand, bet] -> {String.to_integer(bet), hand} end)
    |> Enum.map(fn {bet, hand} -> {bet, hand, get_kind(hand)} end)
    |> Enum.sort(fn {_, hand_a, kind_a}, {_, hand_b, kind_b} ->
      if kind_a == kind_b do
        is_hand_greater?(
          String.graphemes(hand_b),
          String.graphemes(hand_a)
        )
      else
        is_kind_greater?(kind_b, kind_a)
      end
    end)
    |> Enum.map(fn {bet, _, _} -> bet end)
    |> Enum.with_index()
    |> Enum.map(fn {bet, index} -> bet * (index + 1) end)
    |> Enum.sum()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(7) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
