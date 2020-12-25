defmodule Day25.Part1 do
  @doc """
    iex> Day25.Part1.part1(5764801, 17807724)
    14897079
  """
  def part1(card_pub, door_pub) do
    card_loop_size = find_loop_size(card_pub)
    door_loop_size = find_loop_size(door_pub)

    key1 = transform(card_pub, door_loop_size)
    key2 = transform(door_pub, card_loop_size)

    if key1 == key2, do: key1
  end

  @doc """
    iex> Day25.Part1.part1
    4126980
  """
  def part1, do: part1(8_184_785, 5_293_040)

  @doc """
    iex> Day25.Part1.transform(7, 8)
    5764801
    iex> Day25.Part1.transform(17807724, 8)
    14897079
    iex> Day25.Part1.transform(5764801, 11)
    14897079
  """
  def transform(subject, loop_size) do
    Enum.reduce(1..loop_size, 1, fn _, acc -> rem(acc * subject, 20_201_227) end)
  end

  @doc """
    iex> Day25.Part1.find_loop_size(5764801)
    8
    iex> Day25.Part1.find_loop_size(17807724)
    11
  """
  def find_loop_size(public_key, subject \\ 7, acc \\ 1, iteration \\ 0)

  def find_loop_size(public_key, _, public_key, iteration), do: iteration

  def find_loop_size(public_key, subject, acc, iteration),
    do: find_loop_size(public_key, subject, rem(acc * subject, 20_201_227), iteration + 1)
end
