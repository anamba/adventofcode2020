defmodule Day2.Part1 do
  @doc """
      iex> Day2.Part1.part1("day2-sample.txt")
      2
  """
  def part1(input) do
    parse_input(input)
    |> Enum.filter(&valid_password?/1)
    |> Enum.count()
  end

  @doc """
      iex> Day2.Part1.part1
      538
  """
  def part1 do
    parse_input("day2.txt")
    |> Enum.filter(&valid_password?/1)
    |> Enum.count()
  end

  def valid_password?(%{"lb" => lb, "ub" => ub, "letter" => letter, "password" => password}) do
    occurrences =
      password
      |> String.graphemes()
      |> Enum.filter(&(&1 == letter))
      |> Enum.count()

    lb <= occurrences && occurrences <= ub
  end

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(fn line ->
      regex = ~r/^(?<lb>\d+)-(?<ub>\d+) (?<letter>[a-z]): (?<password>[a-z]+)$/

      case Regex.named_captures(regex, line) do
        %{"lb" => lb, "ub" => ub, "letter" => _letter, "password" => _password} = parsed_line ->
          %{parsed_line | "lb" => String.to_integer(lb), "ub" => String.to_integer(ub)}
          # anything else means parse error
      end
    end)
  end
end
