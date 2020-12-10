defmodule Day10.Part1 do
  @doc """
      iex> Day10.Part1.part1("day10-sample.txt")
      35
      iex> Day10.Part1.part1("day10-sample2.txt")
      220
  """
  def part1(filename) do
    {_final, ones, threes} =
      parse_input(filename)
      |> Enum.reduce({0, 0, 0}, fn val, {source, ones, threes} ->
        case val - source do
          1 -> {val, ones + 1, threes}
          3 -> {val, ones, threes + 1}
        end
      end)

    ones * (threes + 1)
  end

  @doc """
      iex> Day10.Part1.part1
      1890
  """
  def part1, do: part1("day10.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sort()
  end
end
