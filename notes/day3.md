# [2020 Day 3](https://adventofcode.com/2020/day/3) Notes

* Took a bit longer than it should to build the data structure, then got hung up for several minutes on a row vs. col mixup when accessing it (forgot that I need to `get_in([y, x])` instead of `[x, y]`).
* Still pretty straightforward, my initial solution worked as expected for both parts (once I got it implemented properly). Part 2 did not add a new twist this time, which was unusual. (Unless of course, you assumed that you would always move down by one...)
* I already realized this during last year's AoC, but once again, I really need to get better acquainted with `Stream`...

```
      -------Part 1--------   -------Part 2--------
Day       Time  Rank  Score       Time  Rank  Score
  3   00:26:45  5925      0   00:39:07  5903      0
  2   00:11:03  2505      0   00:17:05  2463      0
  1   00:10:08  1824      0   00:14:56  2100      0
```
