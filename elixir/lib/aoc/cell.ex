defmodule AOC.Cell do
  @doc ~S"""
  Count the number of cells visited given a string of movements and a number of actors.

  ## e.g.

      iex> AOC.Cell.unique_visited_str(">", 1)
      2

      iex> AOC.Cell.unique_visited_str("^>v<", 1)
      4

      iex> AOC.Cell.unique_visited_str("^v^v^v^v^v", 1)
      2

      iex> AOC.Cell.unique_visited_str("^v", 2)
      3

      iex> AOC.Cell.unique_visited_str("^>v<", 2)
      3

      iex> AOC.Cell.unique_visited_str("^v^v^v^v^v", 2)
      11

  """
  def unique_visited_str(str, actors) do
    String.codepoints(str) |> unique_visited(actors)
  end
  
  defp unique_visited(moves, actors) do
    locs = List.duplicate({0, 0}, actors)
    visited = Enum.into([{0, 0}], HashSet.new)
    HashSet.size(unique_visited(moves, locs, visited))
  end
  defp unique_visited([], _, visited), do: visited
  defp unique_visited(dirs, [loc], visited), do: make_move(loc, dirs, [], visited) 
  defp unique_visited(dirs, [loc_h | loc_r], visited) do
    make_move(loc_h, dirs, loc_r, visited)
  end
  defp make_move(loc, [dir | r] , locs, visited) do
    next = move(loc, dir)
    unique_visited(r, Enum.into([next], locs), HashSet.put(visited, next))
  end
  
  defp move({x, y}, dir) do
    case dir do
      "^" -> {x, y + 1}
      ">" -> {x + 1, y}
      "v" -> {x, y - 1}
      "<" -> {x - 1, y}
    end
  end
end
