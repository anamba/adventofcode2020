defmodule Day24.Part2 do
  @doc """
    iex> Day24.Part2.part2("day24-sample.txt")
    2208
  """
  def part2(filename) do
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
    |> evolve(100)
    |> Map.values()
    |> Enum.count()
  end

  @doc """
    iex> Day24.Part2.part2
    3636
  """
  def part2, do: part2("day24.txt")

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

  def evolve(map, 0), do: map

  def evolve(map, iterations) do
    newmap =
      map
      |> Enum.map(fn {coords, _} -> coords end)
      |> Enum.flat_map(&neighbors(&1))
      |> Enum.uniq()
      |> Enum.map(fn coords ->
        count = adjacent_black_tile_count(coords, map)

        if Map.get(map, coords) == :black do
          unless count == 0 || 2 < count, do: {coords, :black}
        else
          if count == 2, do: {coords, :black}
        end
      end)
      |> Enum.filter(& &1)
      |> Map.new()

    evolve(newmap, iterations - 1)
  end

  def adjacent_black_tile_count(coords, map) do
    Enum.count(neighbors(coords), &(Map.get(map, &1) == :black))
  end

  def neighbors({x, y}) do
    [
      {x + 2, y},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x - 2, y},
      {x - 1, y - 1},
      {x + 1, y - 1}
    ]
  end
end
