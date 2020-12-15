defmodule Day15.Part2 do
  @doc """
      iex> Day15.Part2.part2([0,3,6])
      175594
      iex> Day15.Part2.part2([1,3,2])
      2578
  """
  def part2(starting_numbers) do
    Stream.unfold(initial_state(starting_numbers), &take_turn/1)
    |> Stream.drop(30_000_000 - 1 - length(starting_numbers))
    |> Enum.take(1)
    |> List.first()
  end

  @doc """
      iex> Day15.Part2.part2
      21768614
  """
  def part2, do: part2([17, 1, 3, 16, 19, 0])

  @doc """
    iex> Day15.Part2.take_turn({3, %{0 => 1, 3 => 2, 6 => 3}, 6})
    {0, {4, %{0 => 1, 3 => 2, 6 => 3}, 0}}
    iex> Day15.Part2.take_turn({4, %{0 => 1, 3 => 2, 6 => 3}, 0})
    {3, {5, %{0 => 4, 3 => 2, 6 => 3}, 3}}
  """
  def take_turn({turn, history, last}) do
    case Map.get(history, last) do
      nil ->
        history = Map.put(history, last, turn)
        {0, {turn + 1, history, 0}}

      most_recent ->
        answer = turn - most_recent
        history = Map.put(history, last, turn)
        {answer, {turn + 1, history, answer}}
    end
  end

  @doc """
    iex> Day15.Part2.initial_state([0,3,6])
    {3, %{0 => 1, 3 => 2, 6 => 3}, 6}
  """
  def initial_state(starting_numbers) do
    starting_numbers
    |> Enum.reduce({0, %{}, 0}, fn num, {turn, history, _} ->
      turn = turn + 1
      {turn, Map.put(history, num, turn), num}
    end)
  end
end
