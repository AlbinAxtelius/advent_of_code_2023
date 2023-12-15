defmodule AdventOfCode.Solutions.Day15.Part1 do
  @moduledoc false

  @test_data """
  rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7\
  """

  def hash_rec(codepoints, combined \\ 0)

  def hash_rec([], combined), do: combined

  def hash_rec([current | rest], combined),
    do: hash_rec(rest, rem((combined + current) * 17, 256))

  def hash(string) do
    string |> String.to_charlist() |> hash_rec()
  end

  def solve(input) do
    input
    |> String.split(",")
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(15) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
