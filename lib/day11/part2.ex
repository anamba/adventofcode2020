defmodule Day11.Part2 do
  @doc """
      iex> Day11.Part2.part2("day11-sample.txt", 10, 10)
      26
  """
  def part2(filename, rows, cols) do
    filename
    |> parse_input(rows, cols)
    # |> print_layout(rows, cols)
    |> iterate_until_stable(rows, cols)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  @doc """
      iex> Day11.Part2.part2
      1862
  """
  def part2, do: part2("day11.txt", 91, 90)

  def parse_input(filename, rows, cols) do
    raw =
      "inputs/#{filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)

    for row <- 1..rows, col <- 1..cols do
      {{col, row}, Enum.at(raw, row - 1) |> Enum.at(col - 1)}
    end
    |> Map.new()
  end

  def print_layout(map, rows, cols) do
    for row <- 1..rows do
      for col <- 1..cols do
        map[{col, row}]
      end
      |> Enum.join()
      |> IO.puts()
    end

    IO.puts("")
    map
  end

  def iterate_until_stable(map, rows, cols) do
    case iterate(map, rows, cols) do
      state when state == map -> state
      new_state -> iterate_until_stable(new_state, rows, cols)
    end
  end

  def iterate(map, rows, cols) do
    for row <- 1..rows, col <- 1..cols do
      current_state = Map.get(map, {col, row})
      {{col, row}, next_state({col, row}, current_state, map)}
    end
    |> Map.new()

    # |> print_layout(rows, cols)
  end

  def next_state({col, row}, "L", map) do
    if Enum.all?(visible_seat_values({col, row}, map), &(!seat_occupied?(&1))),
      do: "#",
      else: "L"
  end

  def next_state({col, row}, "#", map) do
    if 5 <= Enum.count(visible_seat_values({col, row}, map), &seat_occupied?/1),
      do: "L",
      else: "#"
  end

  def next_state(_, current_state, _), do: current_state

  # NOTE: cache this if it gets slow
  def visible_seat_values({col, row}, map) do
    [
      first_visible_seat({col, row}, {-1, -1}, map),
      first_visible_seat({col, row}, {0, -1}, map),
      first_visible_seat({col, row}, {1, -1}, map),
      first_visible_seat({col, row}, {-1, 0}, map),
      first_visible_seat({col, row}, {1, 0}, map),
      first_visible_seat({col, row}, {-1, 1}, map),
      first_visible_seat({col, row}, {0, 1}, map),
      first_visible_seat({col, row}, {1, 1}, map)
    ]
  end

  def first_visible_seat({col, row}, {dx, dy}, map) do
    new_pos = {col + dx, row + dy}

    case Map.get(map, new_pos) do
      nil -> nil
      "L" -> "L"
      "#" -> "#"
      "." -> first_visible_seat(new_pos, {dx, dy}, map)
    end
  end

  def seat_occupied?(val), do: val == "#"
end
