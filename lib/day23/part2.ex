defmodule Day23.Part2 do
  @doc """
    iex> Day23.Part2.part2("389125467")
    149245887792
  """
  def part2(str) do
    str
    |> parse_input()
    |> play_game(100)
    |> two_cups_after_one()
    |> Enum.reduce(&Kernel.*/2)
  end

  @doc """
    # iex> Day23.Part2.part2
    # 0
  """
  def part2, do: part2("586439172")

  def parse_input(str) do
    (str
     |> String.graphemes()
     |> Enum.map(&String.to_integer/1)) ++
      Enum.to_list(10..1_000_000)
  end

  def play_game(cups, rounds) do
    Stream.iterate(cups, &play_round/1)
    |> Stream.drop(rounds)
    |> Enum.take(1)
    |> List.first()
  end

  # arrange list so that the first element is always the current cup
  def play_round([current_cup, a, b, c | rest]) do
    dest = select_destination(current_cup - 1, [current_cup, a, b, c])
    {head, tail} = rest |> Enum.split_while(&(&1 != dest))
    head ++ [dest, a, b, c] ++ Enum.drop(tail, 1) ++ [current_cup]
  end

  @doc """
    iex> Day23.Part2.select_destination(3, [2,3])
    1
    iex> Day23.Part2.select_destination(1, [1])
    1_000_000
  """
  def select_destination(0, disallowed), do: select_destination(1_000_000, disallowed)

  def select_destination(candidate, disallowed) do
    if candidate in disallowed do
      select_destination(candidate - 1, disallowed)
    else
      candidate
    end
  end

  @doc """
    iex> Day23.Part2.two_cups_after_one([5,1,2,3,4])
    [2,3]
  """
  def two_cups_after_one(cups) do
    {head, tail} = Enum.split_while(cups, &(&1 != 1))
    (Enum.drop(tail, 1) ++ head) |> Enum.take(2)
  end
end

# mix profile.eprof lib/day23/part2.ex
# Day23.Part2.part2("389125467")
