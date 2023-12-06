defmodule AdventOfCode.Solutions.Day3.Part2 do
  @moduledoc false

  @type number_schematic() :: %{
          :id => non_neg_integer(),
          :value => non_neg_integer(),
          :x => Range.t(),
          :y => non_neg_integer()
        }

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

  @spec get_number_at([number_schematic()], {integer(), integer()}) :: number_schematic() | nil
  def get_number_at(numbers, {x, y}) do
    Enum.find(numbers, fn %{y: row, x: x_range} -> row == y and x in x_range end)
  end

  @spec find_adjacent([number_schematic()], {integer(), integer(), char()}) :: integer()
  def find_adjacent(numbers, {x, y, icon}) do
    found_numbers =
      [
        {x - 1, y - 1},
        {x, y - 1},
        {x + 1, y - 1},
        {x - 1, y},
        {x + 1, y},
        {x - 1, y + 1},
        {x, y + 1},
        {x + 1, y + 1}
      ]
      |> Enum.map(&get_number_at(numbers, &1))
      |> Enum.filter(fn x -> is_nil(x) == false end)
      |> Enum.uniq_by(fn %{id: id} -> id end)
      |> Enum.map(fn %{value: value} -> value end)

    if length(found_numbers) == 2 and icon == "*",
      do: Enum.product(found_numbers),
      else: 0
  end

  @spec parse_numbers(String.t()) :: [number_schematic()]
  def parse_numbers(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      Regex.scan(~r/\d+/, row, return: :index)
      |> List.flatten()
      |> Enum.map(fn {start, length} ->
        %{
          value:
            row
            |> String.slice(start..(start + length - 1))
            |> String.to_integer(),
          x: start..(start + length - 1),
          y: row_index
        }
      end)
    end)
    |> List.flatten()
    |> Enum.with_index(fn map, index -> Map.put(map, :id, index) end)
  end

  @spec parse_icons(String.t()) :: [{}]
  def parse_icons(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      Regex.scan(~r/[^\d.]/, row, return: :index)
      |> List.flatten()
      |> Enum.map(fn {start, _} ->
        {
          start,
          row_index,
          String.at(row, start)
        }
      end)
    end)
    |> List.flatten()
  end

  def solve(input) do
    numbers = parse_numbers(input)
    icons = parse_icons(input)

    icons |> Enum.map(&find_adjacent(numbers, &1)) |> Enum.sum()
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
