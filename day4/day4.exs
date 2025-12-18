defmodule Day4 do
  def solve() do
    File.read!("input.txt")
    |> String.split()
    |> Enum.map(&String.codepoints(&1))
    |> part2()
  end

  defp part1(table) do
    find_removable_rolls(table) |> MapSet.size()
  end

  defp part2(table) do
    {w, h} = size_of(table)
    remove_rolls(table, w, h, 0)
  end

  defp find_removable_rolls(table) do
    {w, h} = size_of(table)

    for i <- 0..(w - 1),
        j <- 0..(h - 1),
        cell_at(table, i, j) == "@",
        reduce: MapSet.new() do
      acc ->
        cond do
          nearby_rolls_at(table, i, j, w, h) < 4 -> MapSet.put(acc, {i, j})
          true -> acc
        end
    end
  end

  defp size_of(table), do: {length(table), hd(table) |> length()}

  defp cell_at(table, i, j), do: Enum.at(table, i) |> Enum.at(j)

  defp nearby_rolls_at(table, i, j, w, h) do
    for x <- (i - 1)..(i + 1),
        x >= 0 && x < w,
        y <- (j - 1)..(j + 1),
        y >= 0 && y < h,
        x != i || y != j,
        reduce: 0 do
      acc -> if cell_at(table, x, y) == "@", do: acc + 1, else: acc
    end
  end

  defp remove_rolls(table, w, h, total_removed_rolls) do
    removable_rolls = find_removable_rolls(table)
    recently_removed_rolls = MapSet.size(removable_rolls)

    case recently_removed_rolls do
      0 ->
        total_removed_rolls

      _ ->
        table2 =
          for i <- 0..(w - 1) do
            for j <- 0..(h - 1) do
              cond do
                MapSet.member?(removable_rolls, {i, j}) -> "."
                true -> cell_at(table, i, j)
              end
            end
          end

        remove_rolls(table2, w, h, total_removed_rolls + recently_removed_rolls)
    end
  end
end

Day4.solve() |> IO.inspect()
