defmodule AdventOfCode.Solutions.Day19.Part1 do
  @moduledoc false

  @test_data """
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}\
  """

  def traverse(_, [{nil, nil, nil, "R"}], _), do: false
  def traverse(_, [{nil, nil, nil, "A"}], _), do: true

  def traverse(part, [{nil, nil, nil, key}], all_workflows),
    do: traverse(part, Map.get(all_workflows, key), all_workflows)

  def traverse(part, [{compare_key, operation, compare, next_flow} | rest], all_workflows) do
    part_value = Map.get(part, compare_key)

    part_valid =
      case operation do
        :lt -> part_value < compare
        :gt -> part_value > compare
        nil -> true
      end

    if part_valid do
      case next_flow do
        "A" ->
          true

        "R" ->
          false

        key ->
          traverse(part, Map.get(all_workflows, key), all_workflows)
      end
    else
      traverse(part, rest, all_workflows)
    end
  end

  def parse_instruction(raw) do
    if Regex.match?(~r/^\w[<>]\d+:\w+$/, raw) do
      [variable, operator, compare_number, goto] =
        Regex.scan(~r/^(\w)([<>])(\d+):(\w+)$/, raw, capture: :all_but_first)
        |> List.flatten()

      {variable, if(operator == "<", do: :lt, else: :gt), String.to_integer(compare_number), goto}
    else
      {nil, nil, nil, raw}
    end
  end

  def parse_workflow(input) do
    [name, instructions] =
      Regex.scan(~r/^(\w+){(.+)}$/, input, capture: :all_but_first) |> List.flatten()

    %{name => instructions |> String.split(",") |> Enum.map(&parse_instruction/1)}
  end

  def parse_part(input) do
    [inner_part] =
      Regex.scan(~r/{(.+)}/, input, capture: :all_but_first)
      |> List.flatten()

    inner_part
    |> String.split(",")
    |> Enum.map(fn x ->
      [key, value] = String.split(x, "=")

      %{key => String.to_integer(value)}
    end)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  def solve(input) do
    [raw_instructions, raw_parts] = input |> String.split("\n\n")

    instructions =
      raw_instructions
      |> String.split("\n")
      |> Enum.map(&parse_workflow/1)
      |> Enum.reduce(%{}, &Map.merge/2)

    parts =
      raw_parts
      |> String.split("\n")
      |> Enum.map(&parse_part/1)

    parts
    |> Enum.filter(&traverse(&1, Map.get(instructions, "in"), instructions))
    |> Enum.flat_map(&Map.values/1)
    |> Enum.sum()
  end

  def test(), do: solve(@test_data)

  def start do
    case AdventOfCode.Input.get(19) do
      {:ok, input} ->
        solve(input)
        |> IO.puts()

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end
  end
end
