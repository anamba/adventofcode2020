defmodule Day17.Part1 do
  @doc """
      iex> Day17.Part1.part1("day17-sample.txt")
      112
  """
  def part1(filename) do
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
      iex> Day17.Part1.part1
      271
  """
  def part1, do: part1("day17.txt")

  # NOTE: for today, coords are {x,y,z}, +y is down (row index), origin is at {0,0,0}
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
        |> Enum.map(fn {char, col} -> {{col, row, 0}, char} end)
      end)
      |> Map.new()

    {min, max} =
      map
      |> Map.keys()
      |> Enum.min_max()

    {map, min, max}
    # |> print_state
  end

  def print_state({map, {xmin, ymin, zmin}, {xmax, ymax, zmax}} = state) do
    for z <- zmin..zmax do
      IO.puts("z=#{z}")

      for y <- ymin..ymax do
        for x <- xmin..xmax do
          Map.get(map, {x, y, z})
        end
        |> Enum.join()
        |> IO.puts()
      end

      IO.puts("")
    end

    state
  end

  def build_stream({map, {xmin, ymin, zmin}, {xmax, ymax, zmax}} = acc) do
    new_map =
      for z <- (zmin - 1)..(zmax + 1), y <- (ymin - 1)..(ymax + 1), x <- (xmin - 1)..(xmax + 1) do
        cube = {x, y, z}
        state = Map.get(map, cube)
        active_neighbor_count = count_active_neighbors(cube, map)

        cond do
          active_neighbor_count == 3 -> {cube, "#"}
          active_neighbor_count == 2 && state == "#" -> {cube, "#"}
          true -> {cube, "."}
        end
      end
      |> Map.new()

    {min, max} =
      new_map
      |> Map.keys()
      |> Enum.min_max()

    {new_map, {new_map, min, max}}
  end

  def count_active_neighbors(cube, map) do
    Enum.count(neighbors(cube), &(Map.get(map, &1) == "#"))
  end

  def neighbors({x, y, z}) do
    for(c <- (z - 1)..(z + 1), b <- (y - 1)..(y + 1), a <- (x - 1)..(x + 1), do: {a, b, c}) --
      [{x, y, z}]
  end
end
