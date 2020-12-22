defmodule Day20.Part2 do
  @doc """
    iex> Day20.Part2.part2("day20-sample.txt")
    273
  """
  def part2(filename) do
    parse_input(filename)
    # |> reorder_tiles()

    # |> with_coordinates()
    # |> get_corner_tile_numbers()
    |> find_corner_tiles()
    |> tiles_to_numbers()
    |> Enum.reduce(&Kernel.*/2)
  end

  @doc """
    iex> Day20.Part2.part2
    0
  """
  def part2, do: part2("day20.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.chunk_every(12)
    |> Enum.map(&parse_tile/1)
  end

  # @directions %{top: {0, -1}, right: {1, 0}, left: {-1, 0}, bottom: {0, 1}}

  # def reorder_tiles(tiles) do
  #   # look for matching bottom edge... if we find one, stick it there and look for a bottom edge of that
  #   # when we hit the bottom, try the right side; when we hit the right edge, look up, then left, then down, and so on
  #   Enum.reduce(tiles, [], fn tile, acc ->

  #   end)
  #   Stream.cycle([{0, 1}, {1,0}, {0, -1}, {-1, 0}])
  #   Stream.
  #   |> find_matching_edge(tile, dir, tiles)
  # end

  def find_corner_tiles(tiles) do
    Enum.filter(tiles, &(length(matching_tiles(&1, tiles)) == 2))
    |> IO.inspect()
  end

  @doc ~S"""
    iex> tile1 = Day20.Part2.parse_tile(["Tile 1:", "##", ".."])
    iex> tile2 = Day20.Part2.parse_tile(["Tile 2:", "##", "##"])
    iex> tiles = [tile1, tile2]
    iex> Day20.Part2.matching_tiles(tile1, tiles)
    [{2, ["##", "##"], ["##", "##"]}]
  """
  def matching_tiles(target, tiles) do
    Enum.filter(tiles -- [target], &tile_matches_tile?(&1, target))
  end

  def tile_matches_tile?(tile1, tile2) do
    Enum.any?(tile_edge_matches(tile1, tile2))
  end

  def tile_edge_matches(tile1, tile2) do
    for edge1 <- [:top, :right, :left, :bottom],
        edge2 <- [:top, :right, :left, :bottom],
        transform <- [:none, :reverse] do
      if edge_with_transform(tile1, edge1, :none) == edge_with_transform(tile2, edge2, transform) do
        {tile1, edge1, tile2, edge2, transform}
      end
    end
    |> Enum.filter(& &1)
  end

  def transform_edge(edge, :none), do: edge
  def transform_edge(edge, :reverse), do: String.reverse(edge)

  def edge_with_transform({_number, rows, _cols}, :top, transform),
    do: transform_edge(List.first(rows), transform)

  def edge_with_transform({_number, rows, _cols}, :bottom, transform),
    do: transform_edge(List.last(rows), transform)

  def edge_with_transform({_number, _rows, cols}, :left, transform),
    do: transform_edge(List.first(cols), transform)

  def edge_with_transform({_number, _rows, cols}, :right, transform),
    do: transform_edge(List.last(cols), transform)

  # def find_matching_edge({number, rows, cols}, {0, drow}, tiles) do

  # end

  # def edges_match?({number, rows, cols}, {0, drow}, {number, rows, cols}) do
  # end

  def with_coordinates(tiles) do
    dim = grid_size(tiles)

    for row <- 0..(dim - 1), col <- 0..(dim - 1), into: %{} do
      {{col, row}, Enum.at(tiles, row * col)}
    end
  end

  def grid_size(tiles), do: :math.sqrt(length(tiles)) |> round()

  def get_corner_tile_numbers(tile_map) do
    {max, max} = Enum.max(Map.keys(tile_map))

    [{0, 0}, {max, 0}, {0, max}, {max, max}]
    |> Enum.map(fn coord ->
      {number, _, _} = Map.get(tile_map, coord)
      number
    end)
  end

  def tiles_to_numbers(tiles) do
    Enum.map(tiles, fn {number, _, _} -> number end)
  end

  def parse_tile(["Tile " <> number_str | rows]) do
    {number, _} = Integer.parse(number_str)

    rows = Enum.filter(rows, &(String.length(&1) > 1))
    cols = transpose(rows)

    {number, rows, cols}
  end

  def transpose(rows) do
    rows
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Enum.join(Tuple.to_list(&1)))
  end

  @doc ~S"""
    iex> Day20.Part2.transform_tile(Day20.Part2.parse_tile(["Tile 1:", "##", ".."]), {0, false, false})
    {1, ["##", ".."], ["#.", "#."]}
    iex> Day20.Part2.transform_tile(Day20.Part2.parse_tile(["Tile 1:", "##", ".."]), {0, true, false})
    {1, ["..", "##"], [".#", ".#"]}
    iex> Day20.Part2.transform_tile(Day20.Part2.parse_tile(["Tile 1:", "#.", "#."]), {0, false, true})
    {1, [".#", ".#"], ["..", "##"]}
  """
  def transform_tile(tile, transform)

  def transform_tile(tile, {0, false, false}) do
    tile
  end

  def transform_tile({number, rows, _cols}, {rot, true, hflip}) do
    rows = Enum.reverse(rows)
    cols = transpose(rows)
    transform_tile({number, rows, cols}, {rot, false, hflip})
  end

  def transform_tile({number, _rows, cols}, {rot, vflip, true}) do
    cols = Enum.reverse(cols)
    rows = transpose(cols)
    transform_tile({number, rows, cols}, {rot, vflip, false})
  end

  # just don't do this, i guess
  # def transform_tile({number, rows, _cols}, {180, false, false}) do
  #   transform_tile({number, rows, cols}, {0, true, true})
  # end

  def transform_tile({number, rows, _cols}, {90, vflip, hflip}) do
    cols = Enum.reverse(rows)
    rows = transpose(cols)
    transform_tile({number, rows, cols}, {0, vflip, hflip})
  end

  def transform_tile({number, rows, cols}, {270, vflip, hflip}) do
    transform_tile({number, cols, rows}, {0, vflip, hflip})
  end
end
