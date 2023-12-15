defmodule AdventOfCode.Solutions.Day15.Part2 do
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

  def place_lenses(lenses, box \\ [])
  def place_lenses([], box), do: box

  def place_lenses([{:set, key, focal_length} | rest], box) do
    existing_index = Enum.find_index(box, fn {k, _} -> k == key end)

    if existing_index do
      place_lenses(
        rest,
        List.update_at(box, existing_index, fn {k, _} -> {k, focal_length} end)
      )
    else
      place_lenses(
        rest,
        Enum.concat(box, [{key, focal_length}])
      )
    end
  end

  def place_lenses([{:remove, key, _} | rest], box) do
    place_lenses(rest, Enum.filter(box, fn {k, _} -> k != key end))
  end

  def calculate({_, []}), do: 0

  def calculate({box_id, boxes}) do
    boxes
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, focal_length}, position} -> box_id * position * focal_length end)
    |> Enum.sum()
  end

  def solve(input) do
    input
    |> String.split(",")
    |> Enum.map(&Regex.run(~r/([a-z]+)(?:=(\d)|-)/i, &1, capture: :all_but_first))
    |> Enum.map(fn
      [key] -> {:remove, key, nil}
      [key, lens] -> {:set, key, String.to_integer(lens)}
    end)
    |> Enum.group_by(&hash(elem(&1, 1)))
    |> Map.to_list()
    |> Enum.map(fn {box_index, values} -> {box_index + 1, place_lenses(values)} end)
    |> Enum.map(&calculate/1)
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
