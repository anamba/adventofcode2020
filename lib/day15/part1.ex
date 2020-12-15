defmodule Day15.Part1 do
  @doc """
      iex> Day15.Part1.part1([0,3,6])
      436
      iex> Day15.Part1.part1([1,3,2])
      1
  """
  def part1(starting_numbers) do
    Stream.unfold(initial_state(starting_numbers), &take_turn/1)
    |> Stream.drop(2020 - 1 - length(starting_numbers))
    |> Enum.take(1)
    |> List.first()
  end

  @doc """
      iex> Day15.Part1.part1
      694
  """
  def part1, do: part1([17, 1, 3, 16, 19, 0])

  @doc """
    iex> Day15.Part1.take_turn({3, %{0 => 1, 3 => 2, 6 => 3}, 6})
    {0, {4, %{0 => 1, 3 => 2, 6 => 3}, 0}}
    iex> Day15.Part1.take_turn({4, %{0 => 1, 3 => 2, 6 => 3}, 0})
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
    iex> Day15.Part1.initial_state([0,3,6])
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
