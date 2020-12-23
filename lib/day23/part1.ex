defmodule Day23.Part1 do
  @doc """
    iex> Day23.Part1.part1("389125467")
    "67384529"
  """
  def part1(str) do
    str
    |> parse_input()
    |> play_game(100)
    |> cups_after_one
    |> Enum.join()
  end

  @doc """
    iex> Day23.Part1.part1
    "28946753"
  """
  def part1, do: part1("586439172")

  def parse_input(str) do
    str
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def play_game(cups, rounds) do
    Stream.iterate(cups, &play_round/1)
    |> Stream.drop(rounds)
    |> Enum.take(1)
    |> List.first()
  end

  # arrange list so that the first element is always the current cup
  def play_round([current_cup, a, b, c | rest]) do
    dest = select_destination(current_cup, rest)
    {head, tail} = rest |> Enum.split_while(&(&1 != dest))
    head ++ [dest, a, b, c] ++ Enum.drop(tail, 1) ++ [current_cup]
  end

  @doc """
    iex> Day23.Part1.select_destination(3, [2,5,4,6,7])
    2
    iex> Day23.Part1.select_destination(1, [9, 2, 5, 8, 4])
    9
  """
  def select_destination(current, rest) do
    {head, tail} =
      rest
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.split_with(&(&1 < current))

    (head ++ tail) |> List.first()
  end

  @doc """
    iex> Day23.Part1.cups_after_one([5,1,2,3,4])
    [2,3,4,5]
  """
  def cups_after_one(cups) do
    {head, tail} = Enum.split_while(cups, &(&1 != 1))
    Enum.drop(tail, 1) ++ head
  end
end
