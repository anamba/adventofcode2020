defmodule Day9.Part2 do
  @doc """
      iex> Day9.Part2.part2("day9-sample.txt", 127)
      62
  """
  def part2(filename, target) do
    input = parse_input(filename)

    {min, max} =
      input
      |> Stream.unfold(fn
        [] -> nil
        [head | tail] -> {[head | tail], tail}
      end)
      |> Stream.map(fn list ->
        list
        |> Enum.map(&String.to_integer/1)
        |> consecutive_numbers_from_head_that_sums_to_target(target)
      end)
      |> Stream.filter(& &1)
      |> Enum.take(1)
      |> List.first()
      |> Enum.min_max()

    min + max
  end

  @doc """
      iex> Day9.Part2.part2
      13826915
  """
  def part2, do: part2("day9.txt", 105_950_735)

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  def consecutive_numbers_from_head_that_sums_to_target(
        source_list,
        target,
        acc \\ 0,
        output_list \\ []
      )

  def consecutive_numbers_from_head_that_sums_to_target(_list, target, acc, output_list)
      when target == acc,
      do: output_list

  def consecutive_numbers_from_head_that_sums_to_target([head | _], target, sum, _)
      when target < sum + head,
      do: nil

  def consecutive_numbers_from_head_that_sums_to_target([head | tail], target, acc, output_list) do
    consecutive_numbers_from_head_that_sums_to_target(tail, target, acc + head, [
      head | output_list
    ])
  end
end
