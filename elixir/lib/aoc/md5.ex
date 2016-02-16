defmodule AOC.MD5 do
  @doc ~S"""
  Returns `true` if base16 md5 of `data` starts with any of the prefixes given,
  otherwise returns `false`. `prefixes` can be either a single prefix or a list of prefixes.

  ## e.g.

      iex> AOC.MD5.starts_with?("abcdef609043", "000001dbbfa")
      true

      iex> AOC.MD5.starts_with?("abcdef609043", "nope")
      false

      iex> AOC.MD5.starts_with?("pqrstuv1048970", "000006136ef")
      true

  """
  def starts_with?(data, prefixes) do
    String.starts_with?(md5(data), prefixes)
  end
  defp md5(data) do
    Base.encode16(:erlang.md5(data), case: :lower)
  end

  @doc ~S"""
  Returns the smallest decimal number that can be appended to `data` to produce a base16 md5
  that starts with `prefix`

  ## e.g.

      iex> AOC.MD5.find_prefix("abcdef", "e10311")
      5

  """
  def find_prefix(data, prefix, next \\ 1) do
    if AOC.MD5.starts_with?(data <> Integer.to_string(next), prefix) do
      next
    else
      AOC.MD5.find_prefix(data, prefix, next + 1)
    end
  end
end
