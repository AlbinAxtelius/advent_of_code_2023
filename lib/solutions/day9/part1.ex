defmodule AdventOfCode.Solutions.Day9.Part1 do
  @moduledoc false

  @test_data """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45\
  """

  @spec differences([integer()]) :: [integer()]
  def differences(xs) do
    xs
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x, y] -> y - x end)
  end

  def generate_change_sets(changes) do
    [latest_change | _] = changes

    if Enum.all?(latest_change, fn x -> x == 0 end) do
      changes
    else
      generate_change_sets(
        Enum.concat(
          [differences(latest_change)],
          changes
        )
      )
    end
  end

  @spec extrapolate([integer()]) :: any()
  def extrapolate(xs) do
    change_sets = generate_change_sets([xs])

    Enum.reduce(change_sets, 0, fn
      change_set, acc ->
        acc + Enum.at(change_set, -1)
    end)
  end

  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn x ->
      x
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> extrapolate()
    end)
    |> Enum.sum()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(9) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
