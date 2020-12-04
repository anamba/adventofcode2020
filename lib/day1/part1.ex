defmodule Day1.Part1 do
  @doc """
      iex> Day1.Part1.part1("day1-sample.txt")
      514579
  """
  def part1(filename) do
    [a, b] = look_for_complement(2020, parse_input(filename))
    a * b
  end

  @doc """
      iex> Day1.Part1.part1
      744475
  """
  def part1 do
    part1("day1.txt")
  end

  def look_for_complement(_target, []), do: :error

  def look_for_complement(target, [i | rest]) do
    if (target - i) in rest do
      [i, target - i]
    else
      look_for_complement(target, rest)
    end
  end

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
