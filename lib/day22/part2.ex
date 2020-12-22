defmodule Day22.Part2 do
  @doc """
    iex> Day22.Part2.part2("day22-sample-p1.txt", "day22-sample-p2.txt")
    291
  """
  def part2(p1filename, p2filename) do
    [parse_input(p1filename), parse_input(p2filename)]
    |> Enum.with_index()
    |> play_game()
    |> score_deck()
  end

  @spec part2 :: number
  @doc """
    iex> Day22.Part2.part2
    31854
  """
  def part2, do: part2("day22-p1.txt", "day22-p2.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def play_game(decks, memory \\ MapSet.new(), round \\ 1)
  def play_game([deck], _, _), do: deck

  def play_game(decks, memory, round) do
    if MapSet.member?(memory, decks) do
      decks
      |> Enum.sort_by(fn {_, player} -> player end)
      |> List.first()
    else
      decks
      # |> IO.inspect(label: "start of round #{round}")
      |> play_one_card_each()
      # |> IO.inspect(label: "top cards")
      |> distribute_cards_to_winner()
      # |> IO.inspect(label: "end of round #{round}")
      |> remove_losers()
      # |> IO.inspect(label: "after removing losers")
      |> play_game(MapSet.put(memory, decks), round + 1)
    end
  end

  def play_one_card_each(decks) do
    Enum.reduce(decks, {[], []}, fn {[top_card | rest], player}, {cards, decks} ->
      {[{top_card, player} | cards], [{rest, player} | decks]}
    end)
  end

  def remove_losers(decks) do
    Enum.filter(decks, fn {deck, _player} -> length(deck) > 0 end)
  end

  def score_deck({deck, _player}) do
    deck
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {card, multiplier} -> card * multiplier end)
    |> Enum.sum()
  end

  def distribute_cards_to_winner({cards, decks}) do
    winner =
      case decks_for_subgame({cards, decks}) do
        nil ->
          cards
          |> Enum.sort_by(fn {card, _player} -> card end)
          |> List.last()
          |> elem(1)

        decks ->
          play_game(decks)
          |> elem(1)
      end

    cards =
      cards
      |> Enum.sort_by(fn {_card, player} -> player == winner end)
      |> Enum.reverse()
      |> Enum.map(&elem(&1, 0))

    decks
    |> Enum.map(fn {deck, player} ->
      if player == winner do
        {deck ++ cards, player}
      else
        {deck, player}
      end
    end)
  end

  def decks_for_subgame({cards, decks}) do
    cards_and_decks = Enum.zip(cards, decks)

    if Enum.all?(cards_and_decks, fn {{card, _}, {deck, _}} -> card <= length(deck) end) do
      cards_and_decks
      |> Enum.map(fn {{card, player}, {deck, player}} -> {Enum.take(deck, card), player} end)
    end
  end
end
