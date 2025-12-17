defmodule Day2 do
  def solve() do
    File.read!("input.txt")
    |> String.trim("\n")
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(0, fn range, invalid_sum ->
      [start_id, end_id] = range |> Enum.map(&String.to_integer/1)
      invalid_sum + (start_id..end_id |> Enum.reduce(0, &part2/2))
    end)
  end

  def part1(id, sum) do
    digit_list = Integer.to_string(id) |> String.to_charlist()
    half_len = div(length(digit_list), 2)

    cond do
      Enum.take(digit_list, half_len) == Enum.drop(digit_list, half_len) -> sum + id
      true -> sum
    end
  end

  def part2(id, sum) do
    digit_list = Integer.to_string(id) |> String.to_charlist()
    len = length(digit_list)
    half_len = div(len, 2)

    chunk_lens = (1..half_len//1) |> Enum.filter(&(Integer.mod(len, &1) == 0))

    Enum.reduce_while(chunk_lens, sum, fn (len, sum2) ->
        [first_chunk|chunks] = Enum.chunk_every(digit_list, len)
        cond do
            Enum.all?(chunks, &(&1 == first_chunk)) -> {:halt, sum2 + id}
            true -> {:cont, sum2}
        end
    end)
  end
end

Day2.solve() |> IO.inspect()
