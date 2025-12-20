defmodule Day6 do
  def solve() do
    File.read!("input.txt")
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.reverse()
    |> split_columns()
    |> Enum.zip()
    |> Enum.map(fn tuple ->
        tuple
        |> Tuple.to_list()
        |> part2()
    end)
    |> Enum.sum()
  end

  def split_columns([ops | values]) do
    chunk_fun = fn char, acc ->
      case char do
        " " -> {:cont, [char | acc]}
        _ -> {:cont, Enum.reverse(tl(acc)), [char]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end

    [first | rest] = ops |> String.codepoints()

    col_widths =
      Enum.chunk_while(rest, [first], chunk_fun, after_fun)
      |> Enum.map(fn col -> length(col) end)

    split_rows =
      for value_row <- Enum.map(values, &String.codepoints/1) do
        Enum.reduce(col_widths, {[], value_row}, fn width, {cols, remaining_values} ->
          {
            [Enum.take(remaining_values, width) | cols],
            Enum.drop(remaining_values, width + 1)
          }
        end)
        |> elem(0)
        |> Enum.reverse()
        |> Enum.map(&Enum.join/1)
      end

    [String.split(ops)|split_rows]
  end

  def part1([op | values]) do
    values
    |> Enum.map(fn val -> String.trim(val) |> String.to_integer() end)
    |> then(fn values ->
      case String.trim(op) do
        "+" -> Enum.sum(values)
        "*" -> Enum.product(values)
      end
    end)
  end

  def part2([op | values]) do
    values
    |> Enum.reverse()
    |> Enum.map(&String.codepoints/1)
    |> Enum.zip()
    |> Enum.map(fn tuple ->
      tuple
      |> Tuple.to_list()
      |> Enum.join()
      |> String.trim()
    end)
    |> then(&part1([op | &1]))
  end
end

Day6.solve() |> IO.inspect()
