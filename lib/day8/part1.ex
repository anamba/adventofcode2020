defmodule Day8.Part1 do
  @doc """
      iex> Day8.Part1.part1("day8-sample.txt")
      5
  """
  def part1(filename) do
    parse_input(filename)
    |> execute_program()
  end

  @doc """
      iex> Day8.Part1.part1
      1949
  """
  def part1, do: part1("day8.txt")

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

  def execute_program(program, instruction \\ 1, accumulator \\ 0, visited \\ [])

  def execute_program(program, instruction, accumulator, visited) do
    if instruction in visited do
      accumulator
    else
      case program[instruction] do
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
