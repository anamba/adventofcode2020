# [2020 Day 10](https://adventofcode.com/2020/day/10) Notes

* So the clear strategy here was to look for streaks of +1s, count possible combinations for each, then multiply those together.
* First, I tried to find a clever way to avoid enumerating all possible +1 sequences, but couldn't quite figure out the pattern.
* However, even once I gave up and started trying to enumerate the sequences, it wasn't as easy as I expected. Then again, I didn't check to see whether there were any sequences longer than 6 (which I computed by hand for the doctests), I might have wasted a lot of time there.
* I thought about caching the combination counts by length, but ended up not needing it since it was already fast. For next time though, I found a [simple cache implementation](https://github.com/thiagopromano/AdventOfCode/blob/main/lib/2020/10.ex) (to avoid having to pass a cache map around everywhere). Here it is with some cosmetic changes:

```elixir
  defmodule Cache do
    use Agent
    def start_link() do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end
    def fetch(key) do
      Agent.get(__MODULE__, &Map.fetch(&1, key))
    end
    def put(key, value) do
      Agent.update(__MODULE__, &Map.put(&1, key, value))
    end
  end
```

Usage:
```elixir
  Cache.start_link()
  Cache.put(:key, 123)
  Cache.fetch(:key) # -> 123
```

```
      -------Part 1--------   -------Part 2--------
Day       Time  Rank  Score       Time  Rank  Score
 10   00:09:45  2157      0   02:41:10  7328      0
  9   00:19:02  4883      0   00:46:07  6268      0
  8   00:14:28  3844      0   00:27:11  2689      0
  7   00:37:37  3289      0   01:01:41  3389      0
  6   00:04:12   649      0   00:13:59  2220      0
  5   00:15:18  2538      0   00:20:14  2228      0
  4   00:19:37  3931      0   00:38:17  2122      0
  3   00:26:45  5925      0   00:39:07  5903      0
  2   00:11:03  2505      0   00:17:05  2463      0
  1   00:10:08  1824      0   00:14:56  2100      0
```
