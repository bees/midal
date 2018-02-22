defmodule Midal.HTML.Meeseeks do
  import Meeseeks.XPath
  alias Meeseeks.Result, as: Result

  @behaviour Midal.HTML

  defp level_search(html, target),
    do: Meeseeks.all(html, xpath("//*[not(ancestor::#{target}) and self::#{target}]"))

  def level_scopes(html), do: level_search(html, "*[@itemscope]")

  def level_props(html), do: level_search(html, "*[@itemprop]")

  def tag(html), do: Result.tag(html)

  def attribute(html, attr) do
    case Result.attr(html, attr) do
      nil -> [nil]
      attr_string -> String.split(attr_string, " ")
    end
  end

  def attributes(html) do
    Result.attrs(html)
    |> Enum.map(fn {key, values} ->
      {key, if(values =~ " ", do: String.split(values, " "), else: values)}
    end)
  end

  def text(html), do: Result.text(html)

  def without_attribute(html, attribute) do
    with {tag, attrs, children} = Result.tree(html),
         filtered_attrs = Enum.filter(attrs, fn {attr, _value} -> attr != attribute end) do
      {tag, filtered_attrs, children}
      |> Meeseeks.Parser.parse()
      |> Meeseeks.html()
    end
  end
end
