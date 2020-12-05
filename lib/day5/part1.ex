defmodule Day5.Part1 do
  @doc """
      iex> Day5.Part1.part1("day5-sample.txt")
      820
  """
  def part1(filename) do
    parse_input(filename)
    |> Enum.map(&seat_id/1)
    |> Enum.max()
  end

  @doc """
      iex> Day5.Part1.part1
      989
  """
  def part1, do: part1("day5.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  def parse_record(line) do
    line
  end

  @doc """
      iex> Day5.Part1.seat_id("FBFBBFFRLR")
      357
      iex> Day5.Part1.seat_id("BFFFBBFRRR")
      567
      iex> Day5.Part1.seat_id("FFFBBBFRRR")
      119
      iex> Day5.Part1.seat_id("BBFFBBFRLL")
      820
  """
  def seat_id(boarding_pass) do
    boarding_pass
    |> String.graphemes()
    |> Enum.map(&char_to_digit/1)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {digit, exp}, acc -> acc + Bitwise.bsl(digit, exp) end)
  end

  def char_to_digit(str) do
    case str do
      "B" -> 1
      "F" -> 0
      "R" -> 1
      "L" -> 0
    end
  end
end
