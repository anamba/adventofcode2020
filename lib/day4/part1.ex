defmodule Day4.Part1 do
  @doc """
      iex> Day4.Part1.part1("day4-sample.txt")
      2
  """
  def part1(filename) do
    parse_input(filename)
    |> Enum.count(&all_fields_present?/1)
  end

  @doc """
      iex> Day4.Part1.part1
      204
  """
  def part1, do: part1("day4.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 != ""))
    |> Stream.filter(&(&1 != [""]))
    |> Stream.map(&join_lines/1)
    |> Enum.map(&parse_record/1)

    # |> IO.inspect()
  end

  def join_lines(lines), do: Enum.join(lines, " ")

  @required_fields ["byr", "ecl", "eyr", "iyr", "hcl", "hgt", "pid"]

  def parse_record(line) do
    line
    |> String.split()
    |> Enum.map(fn pair ->
      [field, value] = String.split(pair, ":")
      {field, value}
    end)
    |> Enum.into(%{})
  end

  def all_fields_present?(record) do
    @required_fields -- Map.keys(record) == []
  end
end
