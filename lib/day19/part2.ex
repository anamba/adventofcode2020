defmodule Day19.Part2 do
  @doc """
    iex> Day19.Part2.part2("day19-sample-rules2.txt", "day19-sample-messages2.txt")
    12
  """
  def part2(rules_filename, messages_filename) do
    {rules, messages} = parse_input(rules_filename, messages_filename)

    messages
    |> Enum.map(&message_matches_rule?(&1, 0, rules))
    |> Enum.count(& &1)
  end

  @doc """
    # iex> Day19.Part2.part2
    # -1

    # between 273 and 376
  """
  def part2, do: part2("day19-rules.txt", "day19-messages.txt")

  def parse_input(rules_filename, messages_filename) do
    rules =
      "inputs/#{rules_filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&parse_rule/1)
      |> Map.new()

      # |> Map.put(8, [[42], [42, 8]])
      # |> Map.put(11, [[42, 31], [42, 11, 31]])
      |> Map.put(8, [[42, 8], [42]])
      |> Map.put(11, [[42, 11, 31], [42, 31]])

    # |> IO.inspect(charlists: :as_lists)

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

  @doc """
    iex> {rules, _} = Day19.Part2.parse_input("day19-sample-rules2.txt", "day19-sample-messages2.txt")
    iex> Day19.Part2.message_matches_rule?(["a"], 1, rules)
    true
    iex> Day19.Part2.message_matches_rule?(["b"], 14, rules)
    true
    iex> Day19.Part2.message_matches_rule?(["b", "a"], 24, rules)
    true
    iex> Day19.Part2.message_matches_rule?(["a", "b"], 21, rules)
    true
    iex> Day19.Part2.message_matches_rule?(["b", "a"], 21, rules)
    true
    iex> Day19.Part2.message_matches_rule?(["a", "a"], 21, rules)
    false
    iex> Day19.Part2.message_matches_rule?("bbbba" |> String.graphemes(), 8, rules)
    true
    # 8: 42 | 42 8
    # 42: 10 1
    # 10: 23 14
    # 23: 22 14
    # 22: 14 14
    # bbbba
  """
  def message_matches_rule?(message, num, rules) when is_integer(num) do
    case Map.get(rules, num) do
      char when is_binary(char) ->
        remainders_after_matching_rule(message, char) == [[]]

      [ruleset1] ->
        message_matches_rule?(message, ruleset1, rules)

      [ruleset1, ruleset2] ->
        message_matches_rule?(message, ruleset1, rules) ||
          message_matches_rule?(message, ruleset2, rules)
    end
  end

  def message_matches_rule?(message, ruleset, rules) do
    result =
      evaluate_message_ruleset_combinations([{message, ruleset}], rules)
      |> evaluate_remainders()
      |> Enum.filter(& &1)
      |> Enum.sort_by(&length(&1))
      |> List.first()

    result == []
  end

  @doc """
    iex> Day19.Part2.remainders_after_matching_rule(["a"], "a")
    [[]]
    iex> Day19.Part2.remainders_after_matching_rule(["a", "b"], "a")
    [["b"]]
    iex> Day19.Part2.remainders_after_matching_rule(["a", "b"], "b")
    [nil]
  """
  def remainders_after_matching_rule(message, char)
  def remainders_after_matching_rule([], _), do: [nil]
  def remainders_after_matching_rule([char | rest], char), do: [rest]
  def remainders_after_matching_rule(_, _), do: [nil]

  def remainders_after_matching_rule(message, num, rules)
  def remainders_after_matching_rule([], _, _), do: [[]]

  def remainders_after_matching_rule(message, num, rules) when is_integer(num) do
    case Map.get(rules, num) do
      char when is_binary(char) ->
        remainders_after_matching_rule(message, char)

      [ruleset1] ->
        evaluate_message_ruleset_combinations([{message, ruleset1}], rules)
        |> evaluate_remainders()

      [ruleset1, ruleset2] ->
        evaluate_message_ruleset_combinations([{message, ruleset1}, {message, ruleset2}], rules)
        |> evaluate_remainders()
    end
  end

  def remainders_after_matching_rule(message, ruleset, rules) do
    evaluate_message_ruleset_combinations([{message, ruleset}], rules)
    |> evaluate_remainders()
  end

  def evaluate_remainders(results) when is_list(results) do
    results = Enum.filter(results, & &1)

    if Enum.any?(results, &(&1 == [])),
      do: [[]],
      else: results
  end

  def evaluate_message_ruleset_combinations([], _), do: [nil]

  def evaluate_message_ruleset_combinations([{message, []} | rest], rules),
    do: [message | evaluate_message_ruleset_combinations(rest, rules)]

  def evaluate_message_ruleset_combinations([{message, [rule | other_rules]} | rest], rules) do
    case remainders_after_matching_rule(message, rule, rules) do
      [[]] ->
        [[]]

      [nil] ->
        evaluate_message_ruleset_combinations(rest, rules)

      [] ->
        evaluate_message_ruleset_combinations(rest, rules)

      [new_msg] when is_list(new_msg) ->
        evaluate_message_ruleset_combinations([{new_msg, other_rules} | rest], rules)

      msgs ->
        evaluate_message_ruleset_combinations(
          Enum.map(msgs, fn msg -> {msg, other_rules} end) ++ rest,
          rules
        )
    end
  end
end
