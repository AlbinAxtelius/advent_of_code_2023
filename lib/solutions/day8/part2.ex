defmodule AdventOfCode.Solutions.Day8.Part2 do
  @moduledoc false

  @test_data """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)\
  """

  def traverse(nodes, [current_step | rest], current_node, num_of_steps) do
    if String.ends_with?(current_node, "Z") do
      num_of_steps
    else
      %{^current_node => %{^current_step => next_node}} = nodes

      traverse(nodes, Enum.concat(rest, [current_step]), next_node, num_of_steps + 1)
    end
  end

  @spec parse_nodes(String.t()) :: %{String.t() => %{:left => String.t(), :right => String.t()}}
  def parse_nodes(row) do
    [key, left, right] =
      Regex.scan(~r/\w+/, row)
      |> List.flatten()

    %{key => %{left: left, right: right}}
  end

  @spec parse_instructions(String.t()) :: [:left | :right]
  def parse_instructions(row) do
    row
    |> String.graphemes()
    |> Enum.map(fn
      "R" -> :right
      "L" -> :left
    end)
  end

  @spec lcm(integer(), integer()) :: integer()
  def lcm(a, b),
    do:
      (abs(a * b) / Integer.gcd(a, b))
      |> round()

  @spec rec_lcm([integer()]) :: integer()
  def rec_lcm([a, b | []]), do: lcm(a, b)
  def rec_lcm([a, b | rest]), do: rec_lcm(Enum.concat([lcm(a, b)], rest))

  def solve(input) do
    [instructions, nodes] = String.split(input, "\n\n")

    parsed_nodes =
      Enum.map(String.split(nodes, "\n"), &parse_nodes/1) |> Enum.reduce(&Map.merge/2)

    parsed_instructions = parse_instructions(instructions)

    ghost_starts =
      nodes
      |> String.split("\n")
      |> Enum.map(fn x ->
        String.split(x, " ")
        |> hd()
      end)
      |> Enum.filter(&String.ends_with?(&1, "A"))

    Enum.map(ghost_starts, fn start ->
      traverse(parsed_nodes, parsed_instructions, start, 0)
    end)
    |> rec_lcm()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(8) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
