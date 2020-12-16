defmodule Day16.Part2 do
  def part2(notes_filename, tickets_filename) do
    {notes, my_ticket, nearby_tickets} = parse_input(notes_filename, tickets_filename)
    valid_values = notes_to_mapset(notes)

    valid_tickets =
      Enum.filter(nearby_tickets, &([] == ticket_to_invalid_values(&1, valid_values)))

    mapping = decipher_fields(tickets_to_value_sets(valid_tickets), %{}, notes_to_mapsets(notes))

    [
      "departure location",
      "departure station",
      "departure platform",
      "departure track",
      "departure date",
      "departure time"
    ]
    |> Enum.map(fn field ->
      Enum.at(my_ticket, mapping[field])
    end)
    |> Enum.reduce(&Kernel.*/2)
  end

  @doc """
      iex> Day16.Part2.part2
      279139880759
  """
  def part2, do: part2("day16-notes.txt", "day16-tickets.txt")

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

  def notes_to_mapsets(notes) do
    Enum.map(notes, fn {attr, [[lb1, ub1], [lb2, ub2]]} ->
      {attr, MapSet.new(Enum.to_list(lb1..ub1) ++ Enum.to_list(lb2..ub2))}
    end)
  end

  def ticket_to_invalid_values(ticket, valid_values) do
    Enum.filter(ticket, &(!MapSet.member?(valid_values, &1)))
  end

  def tickets_to_value_sets(tickets) do
    for col <- 0..(length(List.first(tickets)) - 1) do
      for ticket <- tickets do
        Enum.at(ticket, col)
      end
    end
    |> Enum.map(&MapSet.new/1)
    |> Enum.with_index()
  end

  def decipher_fields([], known_fields, _), do: known_fields

  def decipher_fields([{value_set, pos} | unknown_fields], known_fields, field_mapsets) do
    field_candidates = list_candidates(value_set, field_mapsets) -- Map.keys(known_fields)

    case field_candidates do
      [field] -> decipher_fields(unknown_fields, Map.put(known_fields, field, pos), field_mapsets)
      _ -> decipher_fields(unknown_fields ++ [{value_set, pos}], known_fields, field_mapsets)
    end
  end

  def list_candidates(value_set, field_mapsets) do
    field_mapsets
    |> Enum.filter(fn {_, valid_values} -> MapSet.subset?(value_set, valid_values) end)
    |> Enum.map(fn {field, _} -> field end)
  end
end
