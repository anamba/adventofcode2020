defmodule Day1.Part2 do
  @doc """
      iex> Day1.Part2.part2("day1-sample.txt")
      241861950
  """
  def part2(filename) do
    [a, b, c] = look_for_triple(2020, parse_input(filename))
    a * b * c
  end

  @doc """
      iex> Day1.Part2.part2
      70276940
  """
  def part2 do
    part2("day1.txt")
  end

  def look_for_triple(_target, []), do: :error

  def look_for_triple(target, [i | rest]) do
    case look_for_complement(target - i, rest) do
      :error -> look_for_triple(target, rest)
      [a, b] -> [i, a, b]
    end
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
