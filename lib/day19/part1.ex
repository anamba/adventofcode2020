defmodule Day19.Part1 do
  @doc """
    iex> Day19.Part1.part1("day19-sample-rules.txt", "day19-sample-messages.txt")
    2
  """
  def part1(rules_filename, messages_filename) do
    {rules, messages} = parse_input(rules_filename, messages_filename)

    messages
    |> Enum.map(&message_matches_rule?(&1, 0, rules))
    |> Enum.count(& &1)
  end

  @doc """
    iex> Day19.Part1.part1
    173
  """
  def part1, do: part1("day19-rules.txt", "day19-messages.txt")

  def parse_input(rules_filename, messages_filename) do
    rules =
      "inputs/#{rules_filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&parse_rule/1)
      |> Map.new()

    messages =
      "inputs/#{messages_filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)

    {rules, messages}
  end

  def parse_rule(str) do
    [number, definition] = String.split(str, ": ")

    definition =
      case definition do
        "\"" <> a ->
          a |> String.trim_trailing("\"")

        rulesets ->
          rulesets
          |> String.split(" | ")
          |> Enum.map(fn str -> String.split(str) |> Enum.map(&String.to_integer/1) end)
      end

    {String.to_integer(number), definition}
  end

  def message_matches_rule?(message, num, rules) when is_integer(num) do
    case Map.get(rules, num) do
      char when is_binary(char) ->
        remainder_after_matching_rule(message, char) == []

      [ruleset1] ->
        message_matches_rule?(message, ruleset1, rules)

      [ruleset1, ruleset2] ->
        message_matches_rule?(message, ruleset1, rules) ||
          message_matches_rule?(message, ruleset2, rules)
    end
  end

  def message_matches_rule?(message, ruleset, rules) do
    Enum.reduce(ruleset, message, fn num, message ->
      message && remainder_after_matching_rule(message, num, rules)
    end) == []
  end

  def remainder_after_matching_rule([], _), do: nil
  def remainder_after_matching_rule([char | rest], char), do: rest
  def remainder_after_matching_rule(_, _), do: nil

  def remainder_after_matching_rule([], _, _), do: []

  def remainder_after_matching_rule(message, num, rules) when is_integer(num) do
    case Map.get(rules, num) do
      char when is_binary(char) ->
        remainder_after_matching_rule(message, char)

      [ruleset1] ->
        remainder_after_matching_rule(message, ruleset1, rules)

      [ruleset1, ruleset2] ->
        case remainder_after_matching_rule(message, ruleset1, rules) do
          nil -> remainder_after_matching_rule(message, ruleset2, rules)
          [] -> []
          list -> list
        end
    end
  end

  def remainder_after_matching_rule(message, ruleset, rules) do
    Enum.reduce(ruleset, message, fn num, message ->
      message && remainder_after_matching_rule(message, num, rules)
    end)
  end
end
