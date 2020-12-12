defmodule Day12.Part1 do
  @doc """
      iex> Day12.Part1.part1("day12-sample.txt")
      25
  """
  def part1(filename) do
    parse_input(filename)
    |> Enum.reduce({0, 0, "E"}, &move_from/2)
    |> distance_to({0, 0})
  end

  @doc """
      iex> Day12.Part1.part1
      882
  """
  def part1, do: part1("day12.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_instruction/1)
  end

  def parse_instruction(str) do
    {instruction, quantity} = String.split_at(str, 1)
    {instruction, String.to_integer(quantity)}
  end

  def move_from({"N", quantity}, {srcx, srcy, dir}), do: {srcx, srcy - quantity, dir}
  def move_from({"S", quantity}, {srcx, srcy, dir}), do: {srcx, srcy + quantity, dir}
  def move_from({"E", quantity}, {srcx, srcy, dir}), do: {srcx + quantity, srcy, dir}
  def move_from({"W", quantity}, {srcx, srcy, dir}), do: {srcx - quantity, srcy, dir}

  def move_from({"F", quantity}, {srcx, srcy, dir}),
    do: move_from({dir, quantity}, {srcx, srcy, dir})

  @directions ["N", "E", "S", "W"]

  @doc """
      iex> Day12.Part1.move_from({"L", 90}, {0,0,"E"})
      {0,0,"N"}
      iex> Day12.Part1.move_from({"L", 180}, {0,0,"E"})
      {0,0,"W"}
  """
  def move_from({"L", quantity}, {srcx, srcy, dir}) do
    change = div(quantity, 90)
    current = Enum.find_index(@directions, &(&1 == dir))
    {srcx, srcy, Enum.at(@directions, rem(current - change, 4))}
  end

  def move_from({"R", quantity}, {srcx, srcy, dir}) do
    change = div(quantity, 90)
    current = Enum.find_index(@directions, &(&1 == dir))
    {srcx, srcy, Enum.at(@directions, rem(current + change, 4))}
  end

  @doc """
      iex> Day12.Part1.distance_to({0,0, "E"}, {17, 8})
      25
  """
  def distance_to({srcx, srcy, _dir}, {destx, desty}),
    do: abs(destx - srcx) + abs(desty - srcy)
end
