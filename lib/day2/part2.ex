defmodule Day2.Part2 do
  @doc """
      iex> Day2.Part2.part2("day2-sample.txt")
      1
  """
  def part2(input) do
    parse_input(input)
    |> Enum.filter(&valid_password?/1)
    |> Enum.count()
  end

  @doc """
      iex> Day2.Part2.part2
      489
  """
  def part2 do
    parse_input("day2.txt")
    |> Enum.filter(&valid_password?/1)
    |> Enum.count()
  end

  def valid_password?(%{
        "pos1" => pos1,
        "pos2" => pos2,
        "letter" => letter,
        "password" => password
      }) do
    chars = password |> String.graphemes()

    1 ==
      [Enum.at(chars, pos1 - 1) == letter, Enum.at(chars, pos2 - 1) == letter]
      |> Enum.filter(& &1)
      |> Enum.count()
  end

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn line ->
      regex = ~r/^(?<pos1>\d+)-(?<pos2>\d+) (?<letter>[a-z]): (?<password>[a-z]+)$/

      case Regex.named_captures(regex, line) do
        %{"pos1" => pos1, "pos2" => pos2, "letter" => _letter, "password" => _password} =
            parsed_line ->
          %{parsed_line | "pos1" => String.to_integer(pos1), "pos2" => String.to_integer(pos2)}
          # anything else means parse error
      end
    end)
  end
end
