defmodule Day12.Part2 do
  @doc """
      iex> Day12.Part2.part2("day12-sample.txt")
      286
  """
  def part2(filename) do
    parse_input(filename)
    |> Enum.reduce({0, 0, 10, -1}, &move_from/2)
    |> distance_to({0, 0})
  end

  @doc """
      iex> Day12.Part2.part2
      28885
  """
  def part2, do: part2("day12.txt")

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

  def move_from({"N", quantity}, {srcx, srcy, wpx, wpy}), do: {srcx, srcy, wpx, wpy - quantity}
  def move_from({"S", quantity}, {srcx, srcy, wpx, wpy}), do: {srcx, srcy, wpx, wpy + quantity}
  def move_from({"E", quantity}, {srcx, srcy, wpx, wpy}), do: {srcx, srcy, wpx + quantity, wpy}
  def move_from({"W", quantity}, {srcx, srcy, wpx, wpy}), do: {srcx, srcy, wpx - quantity, wpy}

  def move_from({"F", quantity}, {srcx, srcy, wpx, wpy}),
    do: {srcx + wpx * quantity, srcy + wpy * quantity, wpx, wpy}

  @doc """
      iex> Day12.Part2.move_from({"L", 90}, {0,0,1,2})
      {0,0,2,-1}
      iex> Day12.Part2.move_from({"L", 180}, {0,0,1,2})
      {0,0,-1,-2}
      iex> Day12.Part2.move_from({"L", 270}, {0,0,1,2})
      {0,0,-2,1}
      iex> Day12.Part2.move_from({"R", 90}, {0,0,1,2})
      {0,0,-2,1}
      iex> Day12.Part2.move_from({"R", 180}, {0,0,1,2})
      {0,0,-1,-2}
      iex> Day12.Part2.move_from({"R", 270}, {0,0,1,2})
      {0,0,2,-1}
  """
  def move_from({"L", quantity}, {srcx, srcy, wpx, wpy}) do
    case rem(quantity, 360) do
      90 -> {srcx, srcy, wpy, -wpx}
      180 -> {srcx, srcy, -wpx, -wpy}
      270 -> {srcx, srcy, -wpy, wpx}
    end
  end

  def move_from({"R", quantity}, {srcx, srcy, wpx, wpy}) do
    case rem(quantity, 360) do
      90 -> {srcx, srcy, -wpy, wpx}
      180 -> {srcx, srcy, -wpx, -wpy}
      270 -> {srcx, srcy, wpy, -wpx}
    end
  end

  @doc """
      iex> Day12.Part2.distance_to({0,0,0,0}, {17, 8})
      25
  """
  def distance_to({srcx, srcy, _, _}, {destx, desty}),
    do: abs(destx - srcx) + abs(desty - srcy)
end
