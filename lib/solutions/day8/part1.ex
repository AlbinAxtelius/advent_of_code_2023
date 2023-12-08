defmodule AdventOfCode.Solutions.Day8.Part1 do
  @moduledoc false

  @test_data """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)\
  """

  def traverse(_, _, "ZZZ", num_of_steps), do: num_of_steps

  def traverse(nodes, [current_step | rest], current_node, num_of_steps) do
    %{^current_node => %{^current_step => next_node}} = nodes

    traverse(nodes, Enum.concat(rest, [current_step]), next_node, num_of_steps + 1)
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

  def solve(input) do
    [instructions, nodes] = String.split(input, "\n\n")

    parsed_nodes =
      Enum.map(String.split(nodes, "\n"), &parse_nodes/1) |> Enum.reduce(&Map.merge/2)

    parsed_instructions = parse_instructions(instructions)

    traverse(parsed_nodes, parsed_instructions, "AAA", 0)
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
