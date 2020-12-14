defmodule Day14.Part1 do
  @doc """
      iex> Day14.Part1.part1("day14-sample.txt")
      165
  """
  def part1(filename) do
    parse_input(filename)
    |> evaluate
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end

  @doc """
      iex> Day14.Part1.part1
      17028179706934
  """
  def part1, do: part1("day14.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&parse_line/1)
  end

  def parse_line("mask = " <> mask_str) do
    mask =
      mask_str
      |> String.graphemes()
      |> Enum.reverse()

    {:mask, mask}
  end

  def parse_line("mem[" <> str) do
    {addr, rest} = Integer.parse(str)
    "] = " <> val_str = rest
    {:mem, addr, String.to_integer(val_str)}
  end

  def evaluate(instructions) do
    Enum.reduce(instructions, {36, %{}, []}, &evaluate_instruction/2)
  end

  def evaluate_instruction({:mask, new_mask}, {size, memory, _mask}) do
    {size, memory, new_mask}
  end

  def evaluate_instruction({:mem, addr, val}, {size, memory, mask}) do
    {size, Map.put(memory, addr, apply_mask(mask, val)), mask}
  end

  def apply_mask(mask, val) do
    digits = Integer.digits(val, 2) |> Enum.reverse()

    for {mask_digit, i} <- Enum.with_index(mask) do
      case mask_digit do
        "0" -> 0
        "1" -> 1
        _ -> Enum.at(digits, i) || 0
      end
    end
    |> Enum.reverse()
    |> Integer.undigits(2)
  end
end
