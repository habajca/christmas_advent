defmodule AOC do
  defp open_file(day) do
    {:ok, input} = File.read"./inputs/day_#{ Integer.to_string(day) }.txt"
    input
  end
  def main(["day_3"]) do
    IO.puts("1 person visits #{AOC.Cell.unique_visited_str(open_file(3), 1)} houses")
    IO.puts("2 people visit #{AOC.Cell.unique_visited_str(open_file(3), 2)} houses together")
  end
  def main(["day_4", str]) do
    IO.puts("The lowest number for 5 zeros is #{AOC.MD5.find_prefix(str, "00000")}")
    IO.puts("The lowest number for 6 zeros is #{AOC.MD5.find_prefix(str, "000000")}")
  end
  def main(["day_5"]) do
    IO.puts("The number of nice strings is "
      <> "#{AOC.String.count_nice(open_file(5), &AOC.String.is_nice?/1)}")
    IO.puts("The new number of nice strings is "
      <> "#{AOC.String.count_nice(open_file(5), &AOC.String.is_nice2?/1)}")
  end
end
