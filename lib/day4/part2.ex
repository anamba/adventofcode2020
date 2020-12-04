defmodule Day4.Part2 do
  @doc """
      iex> Day4.Part2.part2("day4-sample2.txt")
      0
      iex> Day4.Part2.part2("day4-sample3.txt")
      4
  """
  def part2(filename) do
    parse_input(filename)
    |> Enum.count(&(all_fields_present?(&1) && all_fields_valid?(&1)))
  end

  @doc """
      iex> Day4.Part2.part2
      179
  """
  def part2, do: part2("day4.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(&(&1 != ""))
    |> Stream.filter(&(&1 != [""]))
    |> Stream.map(&join_lines/1)
    |> Enum.map(&parse_record/1)
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

  def all_fields_valid?(record) do
    Enum.all?(record, fn {field, value} -> valid?(field, value) end)
  end

  def valid?(field, year) when field in ["byr", "eyr", "iyr"] and is_binary(year),
    do: valid?(field, String.to_integer(year))

  def valid?("byr", year) when year in 1920..2002, do: true
  def valid?("iyr", year) when year in 2010..2020, do: true
  def valid?("eyr", year) when year in 2020..2030, do: true
  def valid?("hgt", {cm, "cm"}) when cm in 150..193, do: true
  def valid?("hgt", {inch, "in"}) when inch in 59..76, do: true
  def valid?("hgt", {_, _}), do: false
  def valid?("hgt", height), do: valid?("hgt", Integer.parse(height))

  def valid?("hcl", color), do: Regex.match?(~r/^#[0-9a-f]{6}$/, color)

  def valid?("ecl", color) when color in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
    do: true

  def valid?("pid", pid), do: Regex.match?(~r/^[0-9]{9}$/, pid)
  def valid?("cid", _), do: true
  def valid?(_, _), do: false
end
