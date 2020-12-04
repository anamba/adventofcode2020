defmodule Day3.Part2 do
  @doc """
      iex> Day3.Part2.part1("day3-sample.txt", {1,1}, {1, 1})
      2
      iex> Day3.Part2.part1("day3-sample.txt", {1,1}, {3, 1})
      7
      iex> Day3.Part2.part1("day3-sample.txt", {1,1}, {5, 1})
      3
      iex> Day3.Part2.part1("day3-sample.txt", {1,1}, {7, 1})
      4
      iex> Day3.Part2.part1("day3-sample.txt", {1,1}, {1, 2})
      2
      iex> Day3.Part2.part1("day3.txt", {1,1}, {1, 1})
      90
      iex> Day3.Part2.part1("day3.txt", {1,1}, {3, 1})
      278
      iex> Day3.Part2.part1("day3.txt", {1,1}, {5, 1})
      88
      iex> Day3.Part2.part1("day3.txt", {1,1}, {7, 1})
      98
      iex> Day3.Part2.part1("day3.txt", {1,1}, {1, 2})
      45
  """
  def part1(filename, start, slope) do
    parse_input(filename)
    |> count_trees(start, slope)
  end

  @doc """
      iex> Day3.Part2.part2("day3-sample.txt", {1,1}, [{1, 1}, {3, 1}, {5,1}, {7,1}, {1,2}])
      336
      iex> Day3.Part2.part2("day3.txt", {1,1}, [{1, 1}, {3, 1}, {5,1}, {7,1}, {1,2}])
      9709761600
  """
  def part2(filename, start, slopes) do
    slopes
    |> Enum.map(&part1(filename, start, &1))
    |> Enum.reduce(&Kernel.*/2)
  end

  def count_trees(map, start, slope, count \\ 0)
  def count_trees({_map, _width, height}, {_x, y}, _, count) when y > height, do: count

  def count_trees({map, width, height}, {x, y}, {run, rise}, count) do
    # or 1
    {newx, newy} = {x + run, y + rise}
    {mapx, mapy} = {rem(newx - 1, width), newy - 1}

    trees =
      case get_in(map, [mapy, mapx]) do
        "#" -> 1
        _ -> 0
      end

    count_trees({map, width, height}, {newx, newy}, {run, rise}, count + trees)
  end

  def parse_input(filename) do
    map =
      "inputs/#{filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.with_index()
      |> Enum.map(fn {line, index} ->
        {index,
         line
         |> String.graphemes()
         |> Enum.with_index()
         |> Enum.map(fn {char, index} -> {index, char} end)
         |> Enum.into(%{})}
      end)
      |> Enum.into(%{})

    height = map |> Map.keys() |> length
    width = map[0] |> Map.keys() |> length
    {map, width, height}
  end
end
