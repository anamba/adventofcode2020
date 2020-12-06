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
    group = Enum.map(group, &String.graphemes/1)

    Enum.reduce(group, MapSet.new(List.first(group)), fn responses, acc ->
      MapSet.intersection(MapSet.new(responses), acc)
    end)
    |> Enum.count()
  end
end
