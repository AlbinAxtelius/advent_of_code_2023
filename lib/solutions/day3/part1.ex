defmodule AdventOfCode.Solutions.Day3.Part1 do
  @moduledoc false

  @type schematic() :: [
          %{
            :value => String.t(),
            :x => non_neg_integer(),
            :y => non_neg_integer()
          }
        ]

  @test_data """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..\
  """

  @spec get_number_at(schematic(), {integer(), integer()}) :: String.t()

  def get_number_at(_schematic, {x, y}) when x < 0 or y < 0, do: ""

  def get_number_at(schematic, position) do
    case Enum.find(schematic, fn %{x: x, y: y} -> {x, y} == position end) do
      nil ->
        ""

      %{value: value, x: x, y: y} ->
        get_number_at(schematic, {x - 1, y}) <>
          value <> get_number_at(schematic, {x + 1, y})
    end
  end

  @spec parse_input(String.t()) :: schematic()
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {value, column_index} ->
        %{
          value: value,
          x: column_index,
          y: row_index
        }
      end)
    end)
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.filter(fn %{value: value} -> value != "." end)
  end

  def solve(input) do
    input
    |> parse_input()
    |> get_number_at({0, 0})
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(3) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
