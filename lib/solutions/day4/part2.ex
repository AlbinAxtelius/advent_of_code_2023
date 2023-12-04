defmodule AdventOfCode.Solutions.Day4.Part2 do
  @moduledoc false

  @test_data """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11\
  """

  @spec get_points(String.t()) :: non_neg_integer()
  def get_points(row) do
    [_, all_numbers] = String.split(row, ": ")

    [winning_numbers, card_numbers] =
      String.split(all_numbers, " | ")
      |> Enum.map(&String.split(&1, ~r/(?<=\d)\s/))
      |> Enum.map(&MapSet.new/1)

    MapSet.intersection(winning_numbers, card_numbers)
    |> MapSet.size()
  end

  @spec recursive_solve([integer()], [integer()], integer()) :: integer()
  def recursive_solve(original, values, value \\ 0)
  def recursive_solve([], [], value), do: value

  def recursive_solve(original, values, value) do
    [head | rest] = values
    [cards_won | cards_rest] = original

    recursive_solve(
      cards_rest,
      Enum.concat(
        rest |> Enum.take(cards_won) |> Enum.map(&(&1 + head)),
        rest |> Enum.drop(cards_won)
      ),
      value + head
    )
  end

  def solve(input) do
    points =
      input
      |> String.split("\n")
      |> Enum.map(&get_points/1)

    recursive_solve(points, List.duplicate(1, length(points)))
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(4) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
