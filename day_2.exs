defmodule Packages do
  defp parse_dim(str) do
    {dim, _} = Integer.parse(str)
    dim
  end
  def parse(str) do
    String.split(str, "x") |> Enum.map(&parse_dim/1) |> List.to_tuple()
  end
  #defp print({l, w, h}) do
    #IO.puts(Integer.to_string(l) <> "x" <> Integer.to_string(w) <> "x" <> Integer.to_string(h))
  #end

  defp combos({l, w, h}, f), do: [f.(l,w), f.(w,h), f.(l,h)]

  defp to_areas(sides), do: combos(sides, &*/2)
  defp minl(m, []), do: m
  defp minl(m, [h | r]) when m < h, do: minl(m, r)
  defp minl(_, [h | r]), do: minl(h, r)
  defp minl([h | r]), do: minl(h, r)
  def paper(package) do
    sides = to_areas(package)
    (Enum.map(sides, &(&1 * 2)) |> Enum.reduce(0, &+/2)) + minl(sides)
  end

  defp perimeter(w,h), do: 2 * w + 2 * h
  defp to_perimeters(sides), do: combos(sides, &perimeter/2)
  def bow(sides = {l, w, h}), do: minl(to_perimeters(sides)) + l*w*h
end
packages = IO.stream(:stdio, :line) |> Enum.map(&Packages.parse/1) 
Enum.map(packages, &Packages.paper/1) |> Enum.reduce(0, &+/2) |> IO.puts
Enum.map(packages, &Packages.bow/1) |> Enum.reduce(0, &+/2) |> IO.puts
