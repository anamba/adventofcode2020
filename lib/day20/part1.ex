defmodule Day20.Part1 do
  @doc """
    iex> Day20.Part1.part1("day20-sample.txt")
    20899048083289
  """
  def part1(filename) do
    parse_input(filename)
    |> find_corner_tiles()
    |> tiles_to_numbers()
    |> Enum.reduce(&Kernel.*/2)
  end

  @doc """
    iex> Day20.Part1.part1
    29125888761511
  """
  def part1, do: part1("day20.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.chunk_every(12)
    |> Enum.map(&parse_tile/1)
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

  def find_corner_tiles(tiles) do
    Enum.filter(tiles, &(length(matching_tiles(&1, tiles)) == 2))
  end

  @doc ~S"""
    iex> tile1 = Day20.Part1.parse_tile(["Tile 1:", "##", ".."])
    iex> tile2 = Day20.Part1.parse_tile(["Tile 2:", "##", "##"])
    iex> tiles = [tile1, tile2]
    iex> Day20.Part1.matching_tiles(tile1, tiles)
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

  def tiles_to_numbers(tiles) do
    Enum.map(tiles, fn {number, _, _} -> number end)
  end
end
