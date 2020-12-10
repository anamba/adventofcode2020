defmodule Day10.Part2 do
  @doc """
      iex> Day10.Part2.part2("day10-sample.txt")
      8
      iex> Day10.Part2.part2("day10-sample2.txt")
      19208
  """
  def part2(filename) do
    [0 | parse_input(filename)]
    |> Enum.chunk_while(
      [],
      fn
        el, [last | _] = acc when el - last == 3 ->
          {:cont, Enum.reverse(acc), [el]}

        el, acc ->
          {:cont, [el | acc]}
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, Enum.reverse(acc), []}
      end
    )
    |> Enum.reduce(1, fn el, acc ->
      acc * count_combinations(el)
    end)
  end

  @doc """
      iex> Day10.Part2.part2
      49607173328384
  """
  def part2, do: part2("day10.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sort()
  end

  @doc """
      NOTE: If I cared at all about performance, I would cache these based on list length, but it runs plenty fast as is.

      iex> Day10.Part2.count_combinations([4,5,6])
      2
      iex> Day10.Part2.count_combinations([4,5,6,7])
      4
      iex> Day10.Part2.count_combinations([4,5,6,7,8])
      7
      iex> Day10.Part2.count_combinations([4,5,6,7,8,9])
      13
  """
  def count_combinations(list) when length(list) <= 2, do: 1

  def count_combinations(list) do
    enumerate_combinations(list)
    |> Enum.uniq()
    |> Enum.count()
  end

  def enumerate_combinations(list, starting_with \\ [])
  def enumerate_combinations([], prefix), do: [Enum.reverse(prefix)]
  def enumerate_combinations([a | _], [b | _]) when 3 < a - b, do: []

  def enumerate_combinations(list, prefix) when length(list) <= 1,
    do: [Enum.reverse(prefix) ++ list]

  def enumerate_combinations([a | rest], []),
    do: [[a | rest]] ++ enumerate_combinations(rest, [a])

  def enumerate_combinations([a | rest], prefix) do
    [Enum.reverse(prefix) ++ [a | rest]] ++
      enumerate_combinations(rest, prefix) ++ enumerate_combinations(rest, [a | prefix])
  end
end
