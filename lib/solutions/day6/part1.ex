defmodule AdventOfCode.Solutions.Day6.Part1 do
  @moduledoc false

  @test_data """
  Time:      7  15   30
  Distance:  9  40  200\
  """

  @spec get_distance(number(), number()) :: number()
  def get_distance(_, 0), do: 0
  def get_distance(0, _), do: 0
  def get_distance(max_time, time_held), do: time_held * (max_time - time_held)

  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.split(~r/\s+/)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.map(fn {max_time, distance} ->
      Enum.map(0..max_time, &get_distance(max_time, &1))
      |> Enum.filter(&(&1 > distance))
      |> length()
    end)
    |> Enum.product()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(6) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
