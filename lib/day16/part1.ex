defmodule Day16.Part1 do
  @doc """
      iex> Day16.Part1.part1("day16-sample-notes.txt", "day16-sample-tickets.txt")
      71
  """
  def part1(notes_filename, tickets_filename) do
    {notes, my_ticket, nearby_tickets} = parse_input(notes_filename, tickets_filename)
    valid_values = notes_to_mapset(notes)

    invalid_count =
      nearby_tickets
      |> Enum.flat_map(&ticket_to_invalid_values(&1, valid_values))
      |> Enum.sum()
  end

  @doc """
      iex> Day16.Part1.part1
      27802
  """
  def part1, do: part1("day16-notes.txt", "day16-tickets.txt")

  def parse_input(notes_filename, tickets_filename) do
    notes =
      "inputs/#{notes_filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&parse_note/1)

    tickets =
      "inputs/#{tickets_filename}"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.map(&parse_ticket/1)

    [my_ticket] = Enum.take(tickets, 1)
    nearby_tickets = Enum.drop(tickets, 1)

    {notes, my_ticket, nearby_tickets}
  end

  def parse_note(str) do
    [attr, ranges_str] = String.split(str, ": ")

    ranges =
      ranges_str
      |> String.split(" or ")
      |> Enum.map(fn range -> String.split(range, "-") |> Enum.map(&String.to_integer/1) end)

    {attr, ranges}
  end

  def parse_ticket(str) do
    str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def notes_to_mapset(notes) do
    Enum.reduce(notes, MapSet.new(), fn {_attr, [[lb1, ub1], [lb2, ub2]]}, mapset ->
      MapSet.union(mapset, MapSet.new(Enum.to_list(lb1..ub1) ++ Enum.to_list(lb2..ub2)))
    end)
  end

  def ticket_to_invalid_values(ticket, valid_values) do
    Enum.filter(ticket, &(!MapSet.member?(valid_values, &1)))
  end
end
