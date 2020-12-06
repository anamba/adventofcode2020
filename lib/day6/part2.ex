defmodule Day6.Part2 do
  @doc """
      iex> Day6.Part2.part2("day6-sample.txt")
      6
  """
  def part2(filename) do
    parse_input(filename)
    |> Enum.map(&count_common/1)
    |> Enum.sum()
  end

  @doc """
      iex> Day6.Part2.part2
      3276
  """
  def part2, do: part2("day6.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 != ""))
    |> Stream.filter(&(&1 != [""]))
  end

  def count_common(group) do
    group
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.count()
  end
end
