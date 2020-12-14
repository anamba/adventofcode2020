defmodule Day14.Part2 do
  @doc """
      iex> Day14.Part2.part2("day14-sample2.txt")
      208
  """
  def part2(filename) do
    parse_input(filename)
    |> evaluate
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end

  @doc """
      iex> Day14.Part2.part2
      3683236147222
  """
  def part2, do: part2("day14.txt")

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
    {size, assign_with_mask(memory, addr, mask, val), mask}
  end

  def assign_with_mask(memory, addr, mask, val) do
    addrs =
      addr
      |> Integer.digits(2)
      |> Enum.reverse()
      |> apply_mask_fixed(mask)
      |> apply_mask_floating(mask)
      |> List.flatten()

    Enum.reduce(addrs, memory, fn addr, memory -> Map.put(memory, addr, val) end)
  end

  def apply_mask_fixed(addr_digits, mask) do
    for {mask_digit, i} <- Enum.with_index(mask) do
      case mask_digit do
        "0" -> Enum.at(addr_digits, i) || 0
        "1" -> 1
        _ -> Enum.at(addr_digits, i) || 0
      end
    end
  end

  def apply_mask_floating(addr_digits, mask) do
    case Enum.find_index(mask, &(&1 == "X")) do
      nil ->
        addr_digits
        |> Enum.reverse()
        |> Integer.undigits(2)

      index ->
        [
          apply_mask_floating(
            List.replace_at(addr_digits, index, 0),
            List.replace_at(mask, index, "0")
          ),
          apply_mask_floating(
            List.replace_at(addr_digits, index, 1),
            List.replace_at(mask, index, "1")
          )
        ]
    end
  end
end
