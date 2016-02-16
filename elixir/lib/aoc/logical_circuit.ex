defmodule AOC.LogicalCircuit do
  use Bitwise

  @doc ~S"""
  Computes the outputs of a logical circuit

  ## e.g.

      iex> AOC.LogicalCircuit.compute("123 -> x
      ...> 456 -> y
      ...> x AND y -> d
      ...> x OR y -> e
      ...> x LSHIFT 2 -> f
      ...> y RSHIFT 2 -> g
      ...> NOT x -> h
      ...> NOT y -> i") ===
      ...> Enum.into([{"d", 72}, {"e", 507}, {"f", 492}, {"g", 114}, {"h", 65412}, {"i", 65079},
      ...> {"x", 123}, {"y", 456}], HashDict.new())
      true

  """
  def compute(instructions), do String.split(instructions, "\n") |> AOC.LogicalCircuit.compute()

  def compute(instructions) when is_list(instuctions), do: nil

  defp parse_instruction(instucion) do

  end

  defp compute_instruction([l, r], instruction) do
    compute_function(instruction).(l, r)
  end
  
  defp compute_function(instruction) do
    case instruction do
      :and -> &band/2
      :or -> &bor/2
      :lshift -> &lshift(1, &1)
      :rshift -> &rshift(1, &1)
    end
  end
end
