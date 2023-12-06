defmodule AdventOfCode.Solutions.Day6.Part2 do
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
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> (fn [a, b] -> {a, b} end).()
    |> (fn {max_time, distance} ->
          index = Enum.find_index(0..max_time, fn x -> get_distance(max_time, x) > distance end)
          max_time - index * 2 + 1
        end).()
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
