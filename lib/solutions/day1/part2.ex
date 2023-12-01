defmodule AdventOfCode.Solutions.Day1.Part2 do
  @moduledoc false

  @parse_map [
    {"one", 1},
    {"two", 2},
    {"three", 3},
    {"four", 4},
    {"five", 5},
    {"six", 6},
    {"seven", 7},
    {"eight", 8},
    {"nine", 9},
    {"1", 1},
    {"2", 2},
    {"3", 3},
    {"4", 4},
    {"5", 5},
    {"6", 6},
    {"7", 7},
    {"8", 8},
    {"9", 9}
  ]

  @spec parse_row(String.t(), [Integer.t()]) :: String.t()
  def parse_row(row, found_numbers \\ [])

  def parse_row("", found_numbers), do: Enum.join(found_numbers, "")

  def parse_row(row, found_numbers) do
    matched_tuple =
      @parse_map
      |> Enum.find(fn {word, _} -> String.starts_with?(row, word) end)

    new_row = String.slice(row, 1, String.length(row) - 1)

    case matched_tuple do
      nil ->
        parse_row(new_row, found_numbers)

      {_, new_number} ->
        parse_row(new_row, Enum.concat(found_numbers, ["#{new_number}"]))
    end
  end

  @spec solve_row(String.t()) :: Integer.t()
  def solve_row(input) do
    values =
      Regex.replace(~r/[^\d]/, input, "")
      |> String.graphemes()

    case Integer.parse("#{Enum.take(values, 1)}#{Enum.take(values, -1)}") do
      :error -> 0
      {value, _} -> value
    end
  end

  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
    |> Enum.map(&solve_row/1)
    |> Enum.sum()
  end

  def start do
    case AdventOfCode.Input.get(1) do
      {:ok, input} ->
        solve(input)

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
