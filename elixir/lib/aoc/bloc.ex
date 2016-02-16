defmodule AOC.Bloc do
  @moduledoc ~S"""
  -Binary- Data Location Grid
  """

  @doc ~S"""
  Apply a list of instructions and count the number of ons

  ## e.g.

      iex> AOC.Bloc.apply_binary("turn on 0,0 through 9,9\n"
      ...> <> "turn off 0,0 through 9,0\n"
      ...> <> "toggle 4,0 through 5,1")
      90

  """
  def apply_binary(instructions) do
    gen_apply(HashSet.new(), instructions, &AOC.Bloc.binary_apply_to_loc/3) |> Set.size()
  end

  def apply_digital(instruction) do
    values = gen_apply(HashDict.new(), instruction, &AOC.Bloc.digital_apply_to_loc/3) |> Dict.values()
    Enum.reduce(values, &+/2)
  end

  defp gen_apply(init, instructions, applier) do
    instructions_list = String.split(instructions, "\n") |> Enum.map(&split_instr/1)
    apply_to_list(init, instructions_list, applier)
  end

  defp apply_to_list(set, [], _), do: set
  defp apply_to_list(set, [{action, start, stop} | r], applier) do
    AOC.Bloc.apply(set, action, start, stop, applier) |> apply_to_list(r, applier)
  end

  defp split_instr(instr) do
    {prefix, rest} = take_prefix(instr, ["turn on", "turn off", "toggle"])
    split_instr(String.to_atom(prefix), String.lstrip(rest))
  end
  defp split_instr(action, instr) when is_bitstring(instr) do
    split_instr(action,
      Enum.map(String.split(instr, [",", " through "]), fn x ->
        {i, _} = Integer.parse(x)
        i
      end)
    )
  end
  defp split_instr(action, [start_x, start_y, stop_x, stop_y]) do
    {action, {start_x, start_y}, {stop_x, stop_y}}
  end
  defp take_prefix(full, [h | r]) do
    take_prefix_by_cp(String.next_codepoint(full), String.codepoints(h), full, h, r)
  end
  defp take_prefix_by_cp({_, rest}, [], _, prefix, _), do: {prefix, rest}
  defp take_prefix_by_cp({fc, rest}, [pc | pr], full, prefix, rest_prefixes) when fc == pc do
    take_prefix_by_cp(String.next_codepoint(rest), pr, full, prefix, rest_prefixes)
  end
  defp take_prefix_by_cp(_, _, full, _, rest_prefixes), do: take_prefix(full, rest_prefixes)

  @doc ~S"""
  Apply an instruction

  ##e.g.
  
      iex> Set.equal?(AOC.Bloc.apply(HashSet.new(), :"turn on", {0, 0}, {1, 2},
      ...> &AOC.Bloc.binary_apply_to_loc/3),
      ...> Enum.into([{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 1}, {1, 2}], HashSet.new()))
      true

      iex> AOC.Bloc.apply(Enum.into([{0, 0}], HashSet.new()), :"turn off", {0, 0}, {0, 0},
      ...> &AOC.Bloc.binary_apply_to_loc/3)
      #HashSet<[]>

      iex> AOC.Bloc.apply(HashSet.new(), :toggle, {0, 0}, {0, 0},
      ...> &AOC.Bloc.binary_apply_to_loc/3)
      #HashSet<[{0, 0}]>

      iex> AOC.Bloc.apply(Enum.into([{0, 0}], HashSet.new()), :toggle, {0, 0}, {0, 0},
      ...> &AOC.Bloc.binary_apply_to_loc/3)
      #HashSet<[]>

  """
  def apply(set, action, start = {start_x, _}, stop, applier) do
    apply(set, action, start, stop, start_x, applier)
  end
  def apply(set, action, start = {start_x, start_y}, stop = {stop_x, stop_y}, orig_x, applier) do
    set = applier.(set, action, start)
    cond do
      start_x == stop_x and start_y == stop_y ->
        set
      start_x == stop_x ->
        AOC.Bloc.apply(set, action, {orig_x, start_y + 1}, stop, orig_x, applier)
      true ->
        AOC.Bloc.apply(set, action, {start_x + 1, start_y}, stop, orig_x, applier)
    end
  end

  def binary_apply_to_loc(set, action, loc) do
    case action do
      :toggle ->
        if Set.member?(set, loc) do
          Set.delete(set, loc)
        else
          Set.put(set, loc)
        end
      :"turn on" -> Set.put(set, loc)
      :"turn off" -> Set.delete(set, loc)
    end
  end

  def digital_apply_to_loc(dict, action, loc) do
    current = Dict.get(dict, loc, 0)
    case action do
      :toggle -> Dict.put(dict, loc, current + 2)
      :"turn on" -> Dict.put(dict, loc, current + 1)
      :"turn off" when current > 0 -> Dict.put(dict, loc, current - 1)
      _ -> dict
    end
  end
end
