defmodule Day22.Part1 do
  @doc """
    iex> Day22.Part1.part1("day22-sample-p1.txt", "day22-sample-p2.txt")
    306
  """
  def part1(p1filename, p2filename) do
    [parse_input(p1filename), parse_input(p2filename)]
    |> Enum.with_index()
    |> play_game()
    |> score_deck()
  end

  @doc """
    iex> Day22.Part1.part1
    34566
  """
  def part1, do: part1("day22-p1.txt", "day22-p2.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def play_game(decks, round \\ 1)
  def play_game([deck], _), do: deck

  def play_game(decks, round) do
    decks
    # |> IO.inspect(label: "start of round #{round}")
    |> play_one_card_each()
    # |> IO.inspect(label: "top cards")
    |> distribute_cards_to_winner()
    # |> IO.inspect(label: "end of round #{round}")
    |> remove_losers()
    # |> IO.inspect(label: "after removing losers")
    |> play_game(round + 1)
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
      cards
      |> Enum.sort_by(fn {card, _player} -> card end)
      |> List.last()
      |> elem(1)

    cards = Enum.map(cards, &elem(&1, 0)) |> Enum.sort() |> Enum.reverse()

    decks
    |> Enum.map(fn {deck, player} ->
      if player == winner do
        {deck ++ cards, player}
      else
        {deck, player}
      end
    end)
  end
end
