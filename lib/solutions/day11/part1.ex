defmodule AdventOfCode.Solutions.Day11.Part1 do
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

  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

  def add_missing_space(input) do
    empty_space_cols =
      input
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> transpose()
      |> Enum.with_index()
      |> Enum.map(fn {col, index} ->
        has_galaxy? = col |> Enum.any?(fn c -> c !== "." end)

        if has_galaxy?, do: nil, else: index
      end)
      |> Enum.filter(&(!is_nil(&1)))
      |> Enum.reverse()

    input
    |> String.split("\n")
    |> Enum.reduce("", fn row, acc ->
      has_galaxy? = row |> String.graphemes() |> Enum.any?(fn c -> c !== "." end)

      row_with_col_space =
        String.graphemes(row)
        |> Enum.with_index()
        |> Enum.reverse()
        |> Enum.reduce("", fn {letter, index}, acc ->
          if index in empty_space_cols do
            letter <> "." <> acc
          else
            letter <> acc
          end
        end)

      if has_galaxy? do
        acc <> "\n" <> row_with_col_space
      else
        acc <> "\n" <> row_with_col_space <> "\n" <> row_with_col_space
      end
    end)
    |> String.trim()
  end

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

  def parse_input(input),
    do: input |> add_missing_space() |> input_to_coordinates

  def get_distance_between({x_1, y_1}, {x_2, y_2}) do
    x = abs(x_1 - x_2)
    y = abs(y_1 - y_2)

    x + y
  end

  def get_combined_distance(coordinates, acc \\ 0)
  def get_combined_distance([], acc), do: acc

  def get_combined_distance([galaxy | rest], acc) do
    sum = Enum.map(rest, &get_distance_between(galaxy, &1)) |> Enum.sum()

    get_combined_distance(rest, acc + sum)
  end

  def solve(input) do
    input |> parse_input() |> get_combined_distance()
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
