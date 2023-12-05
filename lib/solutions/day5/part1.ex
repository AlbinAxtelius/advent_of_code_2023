defmodule AdventOfCode.Solutions.Day5.Part1 do
  @moduledoc false

  @test_data """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4\
  """

  # {98, 99, 50}
  # {52, 97, 52}
  # 79

  # 79 - 50 = 29
  # 52 + 29 = 81

  def single({min, max, start}, source) do
    cond do
      min <= source and max >= source ->
        source - min + start

      true ->
        nil
    end
  end

  @spec source_to_destination([{integer(), integer(), integer()}], integer()) :: integer()
  def source_to_destination(maps, source) do
    Enum.map(maps, &single(&1, source))
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.at(0, source)
  end

  @spec parse_map_row(binary()) :: {number(), number(), any()}
  def parse_map_row(row) do
    [destination_start, source_start, range] =
      row |> String.split(" ") |> Enum.map(&String.to_integer/1)

    {
      source_start,
      source_start + range - 1,
      destination_start
    }
  end

  def parse_map(map) do
    [title | maps] =
      String.split(map, "\n")

    parsed_maps = Enum.map(maps, &parse_map_row/1)
    [parsed_title | _] = String.split(title, " ")

    %{
      parsed_title => parsed_maps
    }
  end

  def solve(input) do
    [seeds | maps] = String.split(input, "\n\n")

    parsed_maps =
      maps
      |> Enum.map(&parse_map/1)
      |> Enum.reduce(%{}, &Map.merge/2)

    parsed_seeds =
      seeds
      |> String.split(" ")
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    Enum.map(parsed_seeds, fn seed ->
      seed
      |> (&source_to_destination(Map.get(parsed_maps, "seed-to-soil"), &1)).()
      |> (&source_to_destination(Map.get(parsed_maps, "soil-to-fertilizer"), &1)).()
      |> (&source_to_destination(Map.get(parsed_maps, "fertilizer-to-water"), &1)).()
      |> (&source_to_destination(Map.get(parsed_maps, "water-to-light"), &1)).()
      |> (&source_to_destination(Map.get(parsed_maps, "light-to-temperature"), &1)).()
      |> (&source_to_destination(Map.get(parsed_maps, "temperature-to-humidity"), &1)).()
      |> (&source_to_destination(Map.get(parsed_maps, "humidity-to-location"), &1)).()
    end)
    |> Enum.min()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(5) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
