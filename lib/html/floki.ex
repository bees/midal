defmodule Midal.HTML.Floki do
  @behaviour Midal.HTML

  defp level_search(html, target),
    do: Floki.find(html, "#{target}") -- Floki.find(html, "#{target} #{target}")

  def level_scopes(html), do: level_search(html, "[itemscope]")

  def level_props(html), do: level_search(html, "[itemprop]")

  def tag({tag_, _attrs, _children}), do: tag_

  def attribute({_tag, attrs, _children}, attr) do
    {_key, value} = Enum.find(attrs, {nil, nil}, fn {key, _value} -> key == attr end)
    [value]
  end

  def attributes({_tag, attrs, _children}), do: attrs

  def text(html), do: Floki.text(html)

  def without_attribute({tag, attrs, children}, attribute) do
    with filtered_attrs = Enum.filter(attrs, fn {attr, _value} -> attr != attribute end) do
      {tag, filtered_attrs, children}
    end
  end
end
