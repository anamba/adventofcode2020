defmodule Day13.Part2 do
  @doc """
      iex> Day13.Part2.part2("17,x,13,19")
      3417
      iex> Day13.Part2.part2("67,7,59,61")
      754018
      iex> Day13.Part2.part2("67,x,7,59,61")
      779210
      iex> Day13.Part2.part2("67,7,x,59,61")
      1261476
      iex> Day13.Part2.part2("7,13,x,x,59,x,31,19")
      1068781
      iex> Day13.Part2.part2("1789,37,47,1889")
      1202161486
      iex> Day13.Part2.part2("17,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,439,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,x,x,x,x,x,23,x,x,x,x,x,x,x,787,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,19")
      803025030761664
  """
  def part2(bus_list) do
    bus_list =
      bus_list
      |> String.split(",", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn
        {"x", _} -> nil
        {bus, offset} -> {String.to_integer(bus), offset}
      end)
      |> Enum.filter(& &1)

    {time, _, _} =
      bus_list
      |> Enum.reduce({0, 1, []}, fn bus, {start, period, list} ->
        new_list = [bus | list]
        next_start = find_match(new_list, start, period)
        new_period = Enum.reduce(new_list, 1, fn {bus, _}, acc -> bus * acc end)
        {next_start, new_period, new_list}
      end)

    time
  end

  def create_stream({start, _, _, period}) do
    Stream.iterate(start, &(&1 + period))
  end

  def find_intersections([largest | others]) do
    largest
    |> Stream.transform(others, fn target, streams -> streams_include?(target, streams) end)
    |> Stream.filter(fn {_time, valid} -> valid end)
  end

  def streams_include?(target, streams) do
    results = Enum.map(streams, &stream_includes?(target, &1))
    valid = Enum.map(results, fn {valid, _} -> valid end) |> Enum.all?()
    streams = Enum.map(results, fn {_, stream} -> stream end)

    {[{target, valid}], streams}
  end

  def stream_includes?(target, stream) do
    stream = Stream.drop_while(stream, &(&1 < target))
    [last] = Enum.take(stream, 1)

    {last == target, stream}
  end

  def find_match(list, time, increment, iteration \\ 1)

  def find_match([{bus, offset}], 0, _, _), do: bus - rem(offset, bus)

  def find_match(list, time, increment, iteration) do
    if valid_answer?(list, time) do
      time
    else
      find_match(list, time + increment, increment, iteration + 1)
    end
  end

  def valid_answer?(list, time),
    do: Enum.all?(list, fn {bus, offset} -> rem(time + offset, bus) == 0 end)
end
