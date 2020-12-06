defmodule Day6.Part1 do
  @doc """
      iex> Day6.Part1.part1("day6-sample.txt")
      11
  """
  def part1(filename) do
    parse_input(filename)
    |> Enum.map(&count_uniq/1)
    |> Enum.sum()
  end

  @doc """
      iex> Day6.Part1.part1
      6585
  """
  def part1, do: part1("day6.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 != ""))
    |> Stream.filter(&(&1 != [""]))
  end

  def count_uniq(group) do
    group
    |> Enum.join()
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.count()
  end
end
