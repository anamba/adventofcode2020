defmodule Day9.Part1 do
  @doc """
      iex> Day9.Part1.part1("day9-sample.txt", 5)
      127
  """
  def part1(filename, window_size) do
    parse_input(filename)
    |> Stream.chunk_every(window_size + 1, 1, :discard)
    |> Stream.filter(&(!last_is_sum_of_two_earlier_numbers?(&1)))
    |> Enum.take(1)
    |> List.first()
    |> Enum.reverse()
    |> List.first()
  end

  @doc """
      iex> Day9.Part1.part1
      105950735
  """
  def part1, do: part1("day9.txt", 25)

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def last_is_sum_of_two_earlier_numbers?(set) do
    set = Enum.reverse(set)
    [target | rest] = set

    search_space = Enum.filter(rest, &(&1 < target))

    case find_pair_that_sum_to_target(target, search_space) do
      {a, b} ->
        true

      _ ->
        false
    end
  end

  def find_pair_that_sum_to_target(_target, []), do: :not_found

  def find_pair_that_sum_to_target(target, [i | rest]) do
    if (target - i) in rest do
      {i, target - i}
    else
      find_pair_that_sum_to_target(target, rest)
    end
  end
end
