defmodule Day1 do
    def solve() do
        File.read!("input.txt")
            |> String.split("\r\n")
            |> IO.inspect()
            |> Enum.map(fn line ->
                {dir, rot} = String.split_at(line, 1)
                rot = String.to_integer(rot)
                if dir == "L", do: -rot, else: rot
            end)
            |> Enum.reduce({0, 50}, &part2/2)
            |> elem(0)
    end

    defp part1(rot, {password, state}) do
        state2 = Integer.mod(state + rot, 100)
        password2 = password + if state2 == 0, do: 1, else: 0
        {password2, state2}
    end

    defp part2(rot, {password, state}) do
        state2 = Integer.mod(state + rot, 100)
        first_click = if rot < 0 && state > 0, do: state, else: 100-state
        remaining_rot = abs(rot) - first_click

        zeros = cond do
          remaining_rot > 0 -> 1 + div(remaining_rot, 100)
          remaining_rot == 0 -> 1
          true -> 0
        end

        password2 = password + zeros
        {password2, state2}
    end
end

Day1.solve() |> IO.inspect()
