defmodule AdventOfCode.Solutions.Day1.Part1 do
  @moduledoc false

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
