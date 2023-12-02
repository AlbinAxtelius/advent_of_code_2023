defmodule AdventOfCode.Solutions.Day2.Part1 do
  @moduledoc false
  @type game() :: {
          integer(),
          [map()]
        }

  @max_cubes %{
    :red => 12,
    :green => 13,
    :blue => 14
  }

  @spec is_game_valid?(game()) :: boolean()
  def is_game_valid?({_, sets}) do
    Enum.all?(sets, fn set ->
      Enum.all?(set, fn {key, value} ->
        case Map.get(@max_cubes, key) do
          max when value > max ->
            false

          _ ->
            true
        end
      end)
    end)
  end

  @spec parse_row(String.t()) :: game()
  def parse_row(row) do
    [identifier, sets] = String.split(row, ": ")

    game_id =
      identifier
      |> String.trim_leading("Game ")
      |> String.to_integer()

    parsed_sets =
      sets
      |> String.split(";")
      |> Enum.map(fn set ->
        set
        |> String.split(", ")
        |> Enum.map(fn cubes ->
          [number, color] =
            String.split(cubes)

          %{String.to_atom(color) => String.to_integer(number)}
        end)
        |> Enum.reduce(%{}, &Map.merge/2)
      end)

    {game_id, parsed_sets}
  end

  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
    |> Enum.filter(&is_game_valid?/1)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  def start do
    case AdventOfCode.Input.get(2) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
