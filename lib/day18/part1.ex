defmodule Day18.Part1 do
  def part1(filename) do
    parse_input(filename)
    |> Stream.map(&evaluate_line/1)
    |> Enum.sum()
  end

  @doc """
      iex> Day18.Part1.part1
      2743012121210
  """
  def part1, do: part1("day18.txt")

  def parse_input(filename) do
    "inputs/#{filename}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  @doc """
    iex> Day18.Part1.evaluate_line("1 + 2 * 3 + 4 * 5 + 6")
    71
    iex> Day18.Part1.evaluate_line("1 + (2 * 3) + (4 * (5 + 6))")
    51
  """
  def evaluate_line(str) do
    str
    |> str_to_tree()
    |> evaluate_tree
  end

  @doc """
    iex> Day18.Part1.str_to_tree("1 + 2")
    [2, :+, 1]
    iex> Day18.Part1.str_to_tree("(1 + 2)")
    [[2, :+, 1]]
    iex> Day18.Part1.str_to_tree("1 + (2 * 3) + 4")
    [4, :+, [[3, :*, 2], :+, 1]]
    iex> Day18.Part1.str_to_tree("1 + ((2 * 3) + 4)")
    [[4, :+, [3, :*, 2]], :+, 1]
  """
  def str_to_tree(str), do: str_to_tree(String.split(str), [])
  def str_to_tree([], tree), do: tree
  def str_to_tree(["+" | rest], tree), do: str_to_tree(rest, add_to_tree(tree, :+))
  def str_to_tree(["*" | rest], tree), do: str_to_tree(rest, add_to_tree(tree, :*))

  def str_to_tree(["(" <> num | rest], tree) do
    {expr, rest} = read_expression([num | rest])
    subtree = str_to_tree(expr, [])
    str_to_tree(rest, add_to_tree(tree, subtree))
  end

  def str_to_tree([num | rest], tree) do
    {num, _} = Integer.parse(num)
    str_to_tree(rest, add_to_tree(tree, num))
  end

  def add_to_tree(tree, obj) do
    case length(tree) do
      3 -> [obj | [tree]]
      _ -> [obj | tree]
    end
  end

  # read up to closing parenthesis
  def read_expression(list, level \\ 1, acc \\ [])
  def read_expression(list, level, acc) when level <= 0, do: {Enum.reverse(acc), list}

  def read_expression(["(" <> num | list], level, acc),
    do: read_expression(list, level + 1, ["(" <> num | acc])

  def read_expression([el | list], level, acc) do
    if String.ends_with?(el, ")"),
      do:
        read_expression(list, level - (String.graphemes(el) |> Enum.count(&(&1 == ")"))), [
          el | acc
        ]),
      else: read_expression(list, level, [el | acc])
  end

  def evaluate_tree([a, :+, b]) when is_integer(a) and is_integer(b), do: a + b
  def evaluate_tree([a, :*, b]) when is_integer(a) and is_integer(b), do: a * b
  def evaluate_tree([a, op, b]) when is_list(a), do: evaluate_tree([evaluate_tree(a), op, b])
  def evaluate_tree([a, op, b]) when is_list(b), do: evaluate_tree([a, op, evaluate_tree(b)])
end
