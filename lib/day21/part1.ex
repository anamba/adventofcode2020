defmodule Day21.Part1 do
  @doc """
    # iex> Day21.Part1.part1("day21-sample.txt")
    # 5
  """
  def part1(filename) do
    labels = parse_input(filename)

    # key fact: each allergen is found in exactly one ingredient
    list_safe_ingredients(labels)
    |> Enum.map(&count_ingredient_occurrences(labels, &1))
    |> Enum.sum()
  end

  @doc """
    iex> Day21.Part1.part1
    0

    # less than 2685
  """
  def part1, do: part1("day21.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.map(&parse_label/1)
  end

  def parse_label(str) do
    [ingredients_str, allergens_str] = String.split(str, "(contains ")

    ingredients =
      ingredients_str
      |> String.split()

    allergens =
      allergens_str
      |> String.trim_trailing(")")
      |> String.split(", ")

    {ingredients, allergens}
  end

  def all_ingredients(labels) do
    labels
    |> Enum.flat_map(fn {ingredients, _} -> ingredients end)
    |> Enum.uniq()
  end

  def all_allergens(labels) do
    labels
    |> Enum.flat_map(fn {_, allergens} -> allergens end)
    |> Enum.uniq()
  end

  def count_ingredient_occurrences(labels, ingredient) do
    labels
    |> Enum.map(fn {ingredients, _allergens} -> Enum.count(ingredients, &(&1 == ingredient)) end)
    |> Enum.sum()
  end

  def list_safe_ingredients(labels) do
    known_pairs = find_allergen_pairs(labels) |> IO.inspect(label: "known pairs")

    {known_ingredients, known_allergens} =
      Enum.reduce(known_pairs, {[], []}, fn {i, a}, {is, as} -> {[i | is], [a | as]} end)

    unsolved_allergens = all_allergens(labels) -- known_allergens

    case unsolved_allergens do
      [] ->
        all_ingredients(labels) -- known_ingredients
    end
  end

  # def list_ingredients_with_warnings(labels) do
  #   (multiple_allergen_pairs(labels) -- single_allergen_pairs(labels))
  #   |> Enum.uniq()
  #   |> Enum.group_by(fn {i, _a} -> i end, fn {_i, a} -> a end)
  #   |> Map.new()
  # end

  def find_allergen_pairs(labels, known_pairs \\ [])

  def find_allergen_pairs([], known_pairs), do: known_pairs

  def find_allergen_pairs(labels, []),
    do: find_allergen_pairs(labels, list_known_allergen_pairs(labels))

  def find_allergen_pairs(labels, known_pairs) do
    rest = filter_labels_by_known_allergens(labels, known_pairs) |> IO.inspect()

    if (rest == labels) |> IO.inspect() do
      # can't do any better
      known_pairs
    else
      find_allergen_pairs(rest, known_pairs ++ deduce_allergen_pairs(rest))
    end
  end

  def deduce_allergen_pairs(labels) do
    labels
    |> single_allergen_labels()
    |> Enum.group_by(fn {_, [allergen]} -> allergen end, fn {ingredients, _} -> ingredients end)
    |> Enum.map(fn {allergen, ingredient_lists} ->
      {allergen,
       ingredient_lists
       |> Enum.map(&MapSet.new/1)
       |> Enum.reduce(fn list, common -> MapSet.intersection(common, list) end)}
    end)
    |> Enum.filter(fn {_, intersection} -> MapSet.size(intersection) == 1 end)
    |> Enum.map(fn {allergen, intersection} ->
      {intersection |> MapSet.to_list() |> List.first(), allergen}
    end)
    |> IO.inspect(label: "deduce")
  end

  def filter_labels_by_known_allergens(labels, known_pairs) do
    {known_ingredients, known_allergens} =
      Enum.reduce(known_pairs, {[], []}, fn {i, a}, {is, as} -> {[i | is], [a | as]} end)

    labels
    |> Enum.map(fn {ingredients, allergens} ->
      {Enum.filter(ingredients, &(&1 not in known_ingredients)),
       Enum.filter(allergens, &(&1 not in known_allergens))}
    end)
    |> Enum.filter(fn {ingredients, allergens} ->
      length(ingredients) > 0 && length(allergens) > 0
    end)
  end

  def list_known_allergen_pairs(labels) do
    (multiple_allergen_pairs(labels) -- single_allergen_pairs(labels))
    |> Enum.uniq()
    |> Enum.group_by(fn {i, _a} -> i end, fn {_i, a} -> a end)
    |> Enum.filter(fn {_ingredient, allergens} -> length(allergens) == 1 end)
    |> Enum.map(fn {ingredient, [allergen]} -> {ingredient, allergen} end)
    |> IO.inspect()
  end

  def single_allergen_labels(labels) do
    Enum.filter(labels, fn {_ingredients, allergens} -> length(allergens) == 1 end)
  end

  def multiple_allergen_labels(labels) do
    Enum.filter(labels, fn {_ingredients, allergens} -> length(allergens) > 1 end)
  end

  def single_allergen_pairs(labels) do
    labels
    |> single_allergen_labels()
    |> Enum.flat_map(fn {ingredients, allergens} ->
      for ingredient <- ingredients, allergen <- allergens do
        {ingredient, allergen}
      end
    end)
    |> Enum.uniq()
  end

  def multiple_allergen_pairs(labels) do
    labels
    |> multiple_allergen_labels()
    |> Enum.flat_map(fn {ingredients, allergens} ->
      for ingredient <- ingredients, allergen <- allergens do
        {ingredient, allergen}
      end
    end)
  end
end
