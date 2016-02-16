defmodule AOC.String do
  @doc ~S"""
  Arbitrary count nice from new line delimited strings

  ## e.g.

      iex> AOC.String.count_nice("ugknbfddgicrmopn\naaa\njchzalrnumimnmhp", &AOC.String.is_nice?/1)
      2

  """
  def count_nice(super_string, is_nice?) do
    strings = String.split(super_string, "\n")
    Enum.reduce(
      strings,
      0,
      fn(string, acc) ->
        if is_nice?.(string) do
          acc + 1
        else
          acc
        end
      end
    )

  end

  @doc ~S"""
  Arbitry is nice test.

  ## e.g.

      iex> AOC.String.is_nice?("ugknbfddgicrmopn")
      true

      iex> AOC.String.is_nice?("aaa")
      true

      iex> AOC.String.is_nice?("jchzalrnumimnmhp")
      false

      iex> AOC.String.is_nice?("haegwjzuvuyypxyu")
      false

      iex> AOC.String.is_nice?("dvszwmarrgswjxmb")
      false

  """
  def is_nice?(string) do
    contains_many?(string, String.codepoints("aeiou"), 3)
      && Regex.match?(~r/(.)\1/, string) && (not String.contains?(string, ["ab", "cd", "pq", "xy"]))
  end

  defp contains_many?(string, pattern, number) when not is_list(string) do
    contains_many?(["", string], pattern, number)
  end
  defp contains_many?([_, rest], pattern, 1), do: String.contains?(rest, pattern)
  defp contains_many?([_, rest], pattern, number) do
    contains_many?(String.split(rest, pattern, parts: 2), pattern, number - 1)
  end
  defp contains_many?(_, _, _), do: false

  @doc ~S"""
  Another arbitrary niceness test.

  ## e.g.

        iex> AOC.String.is_nice2?("qjhvhtzxzqqjkmpb")
        true

        iex> AOC.String.is_nice2?("xxyxx")
        true

        iex> AOC.String.is_nice2?("uurcxstgmygtbstg")
        false

        iex> AOC.String.is_nice2?("ieodomkazucvgmuy")
        false

  """
  def is_nice2?(string) do
    Regex.match?(~r/(..).*\1/, string) && Regex.match?(~r/(.).\1/, string)
  end
end
