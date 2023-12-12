defmodule AdventOfCode.Solutions.Day11.Part2 do
  @moduledoc false

  @test_data """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....\
  """

  @empty_space 1_000_000

  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

  def is_empty_space?(row), do: not Enum.any?(row, &(&1 != "."))

  def input_to_coordinates(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {row, index} ->
      Regex.scan(~r/#/, row, return: :index)
      |> List.flatten()
      |> Enum.map(fn {start, _} -> {start, index} end)
    end)
    |> List.flatten()
  end

  def parse_input(input) do
    coords = input |> input_to_coordinates

    map_points = String.split(input, "\n") |> Enum.map(&String.graphemes/1)

    empty_spaces_x =
      map_points
      |> Enum.with_index()
      |> Enum.filter(fn {row, _} -> is_empty_space?(row) end)
      |> Enum.map(fn {_, index} -> index end)
      |> MapSet.new()

    empty_spaces_y =
      map_points
      |> transpose()
      |> Enum.with_index()
      |> Enum.filter(fn {row, _} -> is_empty_space?(row) end)
      |> Enum.map(fn {_, index} -> index end)
      |> MapSet.new()

    {empty_spaces_x, empty_spaces_y, coords}
  end

  def get_distance_between({x_1, y_1}, {x_2, y_2}, {x_rows, y_rows}) do
    x = abs(x_1 - x_2)
    y = abs(y_1 - y_2)

    x_empty_space =
      x_1..x_2
      |> MapSet.new()
      |> MapSet.intersection(y_rows)
      |> MapSet.size()

    y_empty_space =
      y_1..y_2
      |> MapSet.new()
      |> MapSet.intersection(x_rows)
      |> MapSet.size()

    [
      x,
      y,
      x_empty_space * max(1, @empty_space - 1),
      y_empty_space * max(1, @empty_space - 1)
    ]
    |> Enum.sum()
  end

  def get_combined_distance(coordinates, empty_rows, acc \\ 0)
  def get_combined_distance([], _, acc), do: acc

  def get_combined_distance([galaxy | rest], c, acc) do
    sum = Enum.map(rest, &get_distance_between(galaxy, &1, c)) |> Enum.sum()

    get_combined_distance(rest, c, acc + sum)
  end

  def solve(input) do
    {x, y, input} = input |> parse_input()

    get_combined_distance(input, {x, y})
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(11) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
