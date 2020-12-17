defmodule Day17.Part2 do
  @doc """
      iex> Day17.Part2.part2("day17-sample.txt")
      848
  """
  def part2(filename) do
    [map] =
      parse_input(filename)
      |> Stream.iterate(&iterate/1)
      |> Stream.drop(6)
      |> Enum.take(1)

    map
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  @doc """
      iex> Day17.Part2.part2
      2064
  """
  def part2, do: part2("day17.txt")

  # NOTE: for today, coords are {x,y,z,w}, +y is down (row index), origin is at {0,0,0,0}
  def parse_input(filename) do
    map =
      "inputs/#{filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, col} -> {{col, row, 0, 0}, char} end)
      end)
      |> Map.new()

    map
    # |> print_state
  end

  def print_state(map) do
    {xmin, xmax} =
      map
      |> Map.keys()
      |> Enum.map(fn {x, _, _, _} -> x end)
      |> Enum.min_max()

    {ymin, ymax} =
      map
      |> Map.keys()
      |> Enum.map(fn {_, y, _, _} -> y end)
      |> Enum.min_max()

    {zmin, zmax} =
      map
      |> Map.keys()
      |> Enum.map(fn {_, _, z, _} -> z end)
      |> Enum.min_max()

    {wmin, wmax} =
      map
      |> Map.keys()
      |> Enum.map(fn {_, _, _, w} -> w end)
      |> Enum.min_max()

    for w <- wmin..wmax, z <- zmin..zmax do
      IO.puts("z=#{z}, w=#{w}")

      for y <- ymin..ymax do
        for x <- xmin..xmax do
          Map.get(map, {x, y, z, w}, ".")
        end
        |> Enum.join()
        |> IO.puts()
      end

      IO.puts("")
    end

    map
  end

  def iterate(map) do
    map
    |> Map.keys()
    |> Enum.flat_map(&neighbors/1)
    |> Enum.uniq()
    |> Enum.map(&evaluate(&1, map))
    |> Enum.filter(& &1)
    |> Map.new()

    # |> print_state()
  end

  def evaluate(cube, map) do
    case {count_active_neighbors(cube, map), Map.get(map, cube)} do
      {3, _} -> {cube, "#"}
      {2, "#"} -> {cube, "#"}
      _ -> nil
    end
  end

  def count_active_neighbors(cube, map) do
    Enum.count(neighbors(cube) -- [cube], &(Map.get(map, &1) == "#"))
  end

  def neighbors({x, y, z, w}) do
    for d <- (w - 1)..(w + 1),
        c <- (z - 1)..(z + 1),
        b <- (y - 1)..(y + 1),
        a <- (x - 1)..(x + 1),
        do: {a, b, c, d}
  end
end

# mix profile.eprof lib/day17/part2.ex
# IO.puts(Day17.Part2.part2())
