defmodule Day8.Part2 do
  @doc """
      iex> Day8.Part2.part2("day8-sample.txt")
      8
  """
  def part2(filename) do
    program = parse_input(filename)

    Stream.map(Map.keys(program), &execute_with_mutated_instruction(program, &1))
    |> Stream.filter(& &1)
    |> Enum.take(1)
    |> List.first()
  end

  @doc """
      iex> Day8.Part2.part2
      2092
  """
  def part2, do: part2("day8.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(&parse_record/1)
    |> Stream.with_index(1)
    |> Stream.map(fn {el, index} -> {index, el} end)
    |> Enum.into(%{})
  end

  def parse_record([instruction, argument]) do
    argument = String.to_integer(String.replace_leading(argument, "+", ""))
    {instruction, argument}
  end

  def execute_with_mutated_instruction(program, mutated_instruction) do
    case program[mutated_instruction] do
      {"nop", argument} ->
        execute_program(Map.put(program, mutated_instruction, {"jmp", argument}))

      {"jmp", argument} ->
        execute_program(Map.put(program, mutated_instruction, {"nop", argument}))

      _ ->
        nil
    end
  end

  def execute_program(program, instruction \\ 1, accumulator \\ 0, visited \\ [])

  def execute_program(program, instruction, accumulator, visited) do
    if instruction in visited do
      nil
    else
      case program[instruction] do
        nil ->
          accumulator

        {"nop", _} ->
          execute_program(program, instruction + 1, accumulator, [instruction | visited])

        {"acc", argument} ->
          execute_program(program, instruction + 1, accumulator + argument, [
            instruction | visited
          ])

        {"jmp", argument} ->
          execute_program(program, instruction + argument, accumulator, [
            instruction | visited
          ])
      end
    end
  end
end
