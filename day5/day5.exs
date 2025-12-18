defmodule Day5 do
  def solve() do
    File.read!("input.txt")
    |> String.split()
    |> parse_lines()
    |> part2()
  end

  defp part1([ranges, ids]) do
    Enum.reduce(ids, 0, fn id, acc ->
      fresh? =
        Enum.any?(ranges, fn [start_id, end_id] ->
          id >= start_id && id <= end_id
        end)

      if fresh?, do: acc + 1, else: acc
    end)
  end

  defp part2([ranges, _]) do
    ranges = Enum.sort_by(ranges, fn [s, _] -> s end)

    Enum.reduce(tl(ranges), [hd(ranges)], fn [s2, _] = r, acc ->
      [_, e1] = hd(acc)

      if e1 >= s2 do
        [merge_ranges(hd(acc), r) | tl(acc)]
      else
        [r | acc]
      end
    end)
    |> Enum.map(fn [s, e] -> e - s + 1 end)
    |> Enum.sum()
  end

  defp merge_ranges([s1, e1], [s2, e2]) do
    if (s1 <= s2 and e1 >= s2) or (s2 <= s1 and e2 >= s1) do
      [min(s1, s2), max(e1, e2)]
    end
  end

  defp parse_lines(lines) do
    [ranges, ids] = lines |> Enum.chunk_by(&String.contains?(&1, "-"))

    ranges2 =
      Enum.map(ranges, fn range ->
        String.split(range, "-") |> Enum.map(&String.to_integer/1)
      end)

    ids2 = Enum.map(ids, &String.to_integer/1)

    [ranges2, ids2]
  end
end

Day5.solve() |> IO.inspect()
