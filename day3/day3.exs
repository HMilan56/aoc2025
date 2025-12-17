defmodule Day3 do
  def solve() do
    File.read!("input.txt")
      |> String.split(["\n", "\r\n"], trim: true)
      |> Enum.map(fn battery_pack ->
        String.codepoints(battery_pack) |> Enum.map(&String.to_integer/1) end)
      |> Enum.map(&part2/1)
      |> Enum.sum()
  end

  defp part1(digits) do
    tens = Enum.take(digits, length(digits)-1) |> Enum.max()
    ones = Enum.drop_while(digits, &(&1 != tens)) |> tl() |> Enum.max()
    tens * 10 + ones
  end

  defp part2(digits) do
    find_digits(digits, 12, []) |> Enum.reduce(0, &(&2 * 10 + &1))
  end

  defp find_digits(_, 0, acc), do: Enum.reverse(acc)

  defp find_digits(digit_list, missing_digit_count, acc) do
    {max, idx} = Enum.with_index(digit_list)
      |> Enum.take(length(digit_list) - missing_digit_count + 1)
      |> Enum.max_by(fn {val, _} -> val end)

    find_digits(Enum.drop(digit_list, idx + 1), missing_digit_count - 1, [max|acc])
  end
end

Day3.solve() |> IO.inspect()
