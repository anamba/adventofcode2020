defmodule Day15.Part2 do
  @doc """
      # iex> Day15.Part2.part2([0,3,6])
      # 175594
      # iex> Day15.Part2.part2([1,3,2])
      # 2578
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
      iex> Day15.Part2.initial_state([0,3,6])
      iex> Day15.Part2.take_turn({3, 6})
      {0, {4, 0}}
      iex> Day15.Part2.take_turn({4, 0})
      {3, {5, 3}}
  """
  def take_turn({turn, last}) do
    answer =
      case :ets.lookup(:history, last) do
        [] -> 0
        [{_, most_recent}] -> turn - most_recent
      end

    :ets.insert(:history, {last, turn})
    {answer, {turn + 1, answer}}
  end

  @doc """
    iex> Day15.Part2.initial_state([0,3,6])
    {3, 6}
  """
  def initial_state(starting_numbers) do
    create_ets_table(:history)

    starting_numbers
    |> Enum.reduce({0, 0}, fn num, {turn, _} ->
      turn = turn + 1
      :ets.insert(:history, {num, turn})
      {turn, num}
    end)
  end

  def create_ets_table(:history) do
    case :ets.whereis(:history) do
      :undefined ->
        :ets.new(:history, [:named_table])

      ref ->
        :ets.delete(ref)
        create_ets_table(:history)
    end
  end
end
