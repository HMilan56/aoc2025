defmodule Day5 do
  def solve() do
    File.read!("input.txt")
    |> String.split()
    |> Enum.split_while(fn line -> String.contains?(line, "-") end)
    |> then(fn {ranges, ids} ->
      {
        Enum.map(ranges, fn r -> r |> String.split("-") |> Enum.map(&String.to_integer/1) end),
        Enum.map(ids, &String.to_integer/1)
      }
    end)
    |> part2()
  end

  defp part1({ranges, ids}) do
    Enum.reduce(ids, 0, fn id, acc ->
      fresh? =
        Enum.any?(ranges, fn [start_id, end_id] ->
          id >= start_id && id <= end_id
        end)

      if fresh?, do: acc + 1, else: acc
    end)
  end

  defp part2({ranges, _}) do
    [first | rest] = Enum.sort(ranges)

    Enum.reduce(rest, [first], fn
      [s2, e2], [[s1, e1] | acc] when e1 >= s2 -> [[s1, max(e1, e2)] | acc]
      r, acc -> [r | acc]
    end)
    |> Enum.map(fn [s, e] -> e - s + 1 end)
    |> Enum.sum()
  end
end

Day5.solve() |> IO.inspect()
