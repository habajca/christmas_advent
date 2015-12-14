defmodule Parens do
  def do_sum("(", sum), do: sum + 1
  def do_sum(")", sum), do: sum - 1
  def do_sum(_, sum), do: sum
  def find_sum(_, sum, depth, sum), do: depth
  def find_sum([], _, _, _), do: raise "Not found"
  def find_sum([ h | r ], sum, depth, q) do
    Parens.find_sum(r, do_sum(h, sum), depth + 1, q)
  end
end

IO.gets("") |> String.codepoints |> Parens.find_sum(0, 0, -1) |> IO.puts
