defmodule Day7.Part2 do
  @doc """
      iex> Day7.Part2.part2("day7-sample.txt")
      32
      iex> Day7.Part2.part2("day7-sample2.txt")
      126
  """
  def part2(filename) do
    (parse_input(filename) |> count_contents("shiny gold")) - 1
  end

  @doc """
      iex> Day7.Part2.part2
      35487
  """
  def part2, do: part2("day7.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_record/1)
    |> Enum.into(%{})
  end

  def parse_record(line) do
    %{"color" => color, "contents" => contents_str} =
      Regex.named_captures(~r/^(?<color>\w+ \w+) bags contain (?<contents>.*+)$/, line)

    contents =
      contents_str
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_bag_with_quantity/1)
      |> Enum.filter(& &1)

    {color, contents}
  end

  def parse_bag_with_quantity("no other bags."), do: nil

  def parse_bag_with_quantity(str) do
    %{"color" => color, "quantity" => quantity} =
      Regex.named_captures(~r/^(?<quantity>\d+) (?<color>\w+ \w+) bag(s?)(\.?)$/, str)

    {color, String.to_integer(quantity)}
  end

  def count_contents(ruleset, target, multiplier \\ 1) do
    case ruleset[target] do
      nil ->
        0

      [] ->
        multiplier

      contents ->
        multiplier +
          (Enum.map(contents, fn {color, quantity} ->
             multiplier * count_contents(ruleset, color, quantity)
           end)
           |> Enum.sum())
    end
  end
end
