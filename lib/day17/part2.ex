defmodule Day17.Part2 do
  @doc """
      iex> Day17.Part2.part2("day17-sample.txt")
      848
  """
  def part2(filename) do
    [map] =
      parse_input(filename)
      |> Stream.unfold(&build_stream/1)
      |> Stream.drop(5)
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

    {min, max} =
      map
      |> Map.keys()
      |> Enum.min_max()

    {map, min, max}
    # |> print_state
  end

  def print_state({map, {xmin, ymin, zmin, wmin}, {xmax, ymax, zmax, wmax}} = state) do
    for w <- wmin..wmax, z <- zmin..zmax do
      IO.puts("z=#{z}, w=#{w}")

      for y <- ymin..ymax do
        for x <- xmin..xmax do
          Map.get(map, {x, y, z}, ".")
        end
        |> Enum.join()
        |> IO.puts()
      end

      IO.puts("")
    end

    state
  end

  def build_stream({map, {xmin, ymin, zmin, wmin}, {xmax, ymax, zmax, wmax}}) do
    new_map =
      for w <- (wmin - 1)..(wmax + 1),
          z <- (zmin - 1)..(zmax + 1),
          y <- (ymin - 1)..(ymax + 1),
          x <- (xmin - 1)..(xmax + 1) do
        cube = {x, y, z, w}
        state = Map.get(map, cube)
        active_neighbor_count = count_active_neighbors(cube, map)

        cond do
          active_neighbor_count == 3 -> {cube, "#"}
          active_neighbor_count == 2 && state == "#" -> {cube, "#"}
          true -> nil
        end
      end
      |> Enum.filter(& &1)
      |> Map.new()

    {xmin, xmax} =
      new_map
      |> Map.keys()
      |> Enum.map(fn {x, _, _, _} -> x end)
      |> Enum.min_max()

    {ymin, ymax} =
      new_map
      |> Map.keys()
      |> Enum.map(fn {_, y, _, _} -> y end)
      |> Enum.min_max()

    {zmin, zmax} =
      new_map
      |> Map.keys()
      |> Enum.map(fn {_, _, z, _} -> z end)
      |> Enum.min_max()

    {wmin, wmax} =
      new_map
      |> Map.keys()
      |> Enum.map(fn {_, _, _, w} -> w end)
      |> Enum.min_max()

    {new_map, {new_map, {xmin, ymin, zmin, wmin}, {xmax, ymax, zmax, wmax}}}
  end

  def count_active_neighbors(cube, map) do
    Enum.count(neighbors(cube), &(Map.get(map, &1) == "#"))
  end

  def neighbors({x, y, z, w}) do
    for(
      d <- (w - 1)..(w + 1),
      c <- (z - 1)..(z + 1),
      b <- (y - 1)..(y + 1),
      a <- (x - 1)..(x + 1),
      do: {a, b, c, d}
    ) --
      [{x, y, z, w}]
  end
end
