defmodule Day13.Part1 do
  @doc """
      iex> Day13.Part1.part1(939, "7,13,x,x,59,x,31,19")
      295
      iex> Day13.Part1.part1(1000067, "17,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,439,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,x,x,x,x,x,23,x,x,x,x,x,x,x,787,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,19")
      205
  """
  def part1(time, bus_list) do
    {wait, first_bus} =
      bus_list
      |> String.split(",", trim: true)
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&earliest_departure_after(&1, time))
      |> Enum.sort()
      |> List.first()

    wait * first_bus
  end

  def earliest_departure_after(bus, time) do
    {bus - rem(time, bus), bus}
  end
end
