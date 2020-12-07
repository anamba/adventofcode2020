defmodule Day7.Part1 do
  @doc """
      iex> Day7.Part1.part1("day7-sample.txt")
      4
  """
  def part1(filename) do
    parse_input(filename)
    |> count_bags_that_can_contain("shiny gold")
  end

  @doc """
      iex> Day7.Part1.part1
      252
  """
  def part1, do: part1("day7.txt")

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

    {color, quantity}
  end

  def count_bags_that_can_contain(ruleset, target) do
    candidates = Map.keys(ruleset) |> Enum.uniq()
    Enum.count(candidates, fn bag -> can_contain?(bag, target, ruleset) end)
  end

  def can_contain?(bag, target, rules, seen \\ [])

  def can_contain?(bag, target, rules, seen) do
    cond do
      bag in seen ->
        false

      contents_include_target(rules[bag], target) ->
        true

      true ->
        Enum.any?(rules[bag], fn {color, _} ->
          can_contain?(color, target, rules, [bag | seen])
        end)
    end
  end

  def contents_include_target(contents, target) do
    Enum.any?(contents, fn {color, _} -> color == target end)
  end
end
