defmodule AdventOfCode.Solutions.Day2.Part2 do
  @moduledoc false

  @type game() :: {
          integer(),
          [map()]
        }

  @spec get_power_value(game()) :: integer()
  def get_power_value({_id, sets}) do
    Enum.reduce(sets, &Map.merge(&1, &2, fn _key, v1, v2 -> max(v1, v2) end))
    |> Map.values()
    |> Enum.product()
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
    |> Enum.map(&get_power_value/1)
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
