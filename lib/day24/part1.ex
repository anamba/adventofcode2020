defmodule Day24.Part1 do
  @doc """
    iex> Day24.Part1.part1("day24-sample.txt")
    10
  """
  def part1(filename) do
    parse_input(filename)
    |> Enum.reduce(%{}, fn directions, map ->
      coords = find_coordinates(directions)

      if Map.get(map, coords) == :black do
        Map.delete(map, coords)
      else
        Map.put(map, coords, :black)
      end
    end)
    # |> IO.inspect()
    |> Map.values()
    |> Enum.count()
  end

  @doc """
    iex> Day24.Part1.part1
    287
  """
  def part1, do: part1("day24.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&tokenize(String.graphemes(&1)))
  end

  def tokenize(chars, tmp \\ [], emitted \\ [])
  def tokenize([], [], emitted), do: emitted

  def tokenize([char | chars], tmp, emitted) do
    case [char | tmp] do
      ["e"] -> tokenize(chars, [], [:e | emitted])
      ["e", "s"] -> tokenize(chars, [], [:se | emitted])
      ["w", "s"] -> tokenize(chars, [], [:sw | emitted])
      ["w"] -> tokenize(chars, [], [:w | emitted])
      ["w", "n"] -> tokenize(chars, [], [:nw | emitted])
      ["e", "n"] -> tokenize(chars, [], [:ne | emitted])
      _ -> tokenize(chars, [char | tmp], emitted)
    end
  end

  # note: n is -y, origin is 0,0, odd rows use odd x's, even rows even
  def find_coordinates(directions, pos \\ {0, 0})
  def find_coordinates([], pos), do: pos

  def find_coordinates([dir | directions], {x, y}) do
    case dir do
      :e -> find_coordinates(directions, {x + 2, y})
      :se -> find_coordinates(directions, {x + 1, y + 1})
      :sw -> find_coordinates(directions, {x - 1, y + 1})
      :w -> find_coordinates(directions, {x - 2, y})
      :nw -> find_coordinates(directions, {x - 1, y - 1})
      :ne -> find_coordinates(directions, {x + 1, y - 1})
    end
  end
end
