defmodule Midal do
  alias Midal.HTML, as: HTML

  @moduledoc """
  A microdata parser for Elixir.
  """

  @doc """
  parse will attempt to extract microdata out of html represented as a string.

  ## Examples

      iex> Midal.parse("<div itemscope><div itemprop='name'>Midal</div></div>")
      {:ok, [%{"name" => "Midal"}]}

  """
  def parse(html) when is_bitstring(html) do
    try do
      {:ok, parse_root_scopes(html)}
    rescue
      e in RuntimeError -> {:error, e}
    end
  end

  def parse!(html) when is_bitstring(html), do: parse_root_scopes(html)

  defp parse_root_scopes(html) do
    scopes = HTML.level_scopes(html)
    scopes_meta_maps = Enum.map(scopes, &parse_scope_meta/1)

    scopes_props =
      scopes
      |> Enum.map(&HTML.level_props/1)
      |> Enum.map(&parse_props/1)

    Enum.zip(scopes_meta_maps, scopes_props)
    |> Enum.map(fn {scope_meta_map, scope_props} -> Map.merge(scope_meta_map, scope_props) end)
  end

  defp parse_scope_meta(html) do
    HTML.attributes(html)
    |> Enum.filter(fn {key, _values} -> key in ["itemtype", "itemid"] end)
    |> Enum.into(%{})
  end

  defp parse_props(prop_list) do
    prop_list
    |> get_prop_maps
    |> Enum.reduce(%{}, fn prop_map, map ->
      Map.merge(map, prop_map, fn _key, value, new_value ->
        handle_key_collision(value, new_value)
      end)
    end)
  end

  defp get_prop_maps(props) do
    props
    |> Enum.map(fn prop -> {HTML.attribute(prop, "itemprop"), get_prop_value(prop)} end)
    |> Enum.flat_map(fn {keys, value} -> for key <- keys, do: %{key => value} end)
  end

  defp handle_key_collision(value, new_value) when is_list(value) do
    [new_value | value]
  end

  defp handle_key_collision(value, new_value) do
    [new_value, value]
  end

  defp get_prop_value(html) do
    # Note: this is safe only because it is invalid to have repeated attributes on the same element
    # https://www.w3.org/TR/html5/syntax.html#elements-attributes
    HTML.attributes(html)
    |> Enum.into(%{})
    |> _get_prop_value(HTML.tag(html), html)
  end

  defp _get_prop_value(%{"itemscope" => _}, _tag, html) do
    Enum.at(parse_root_scopes(HTML.without_attribute(html, "itemprop")), 0)
  end

  defp _get_prop_value(%{"content" => value}, _tag, _html), do: value
  defp _get_prop_value(%{"value" => value}, "data", _html), do: value
  defp _get_prop_value(%{"value" => value}, "meter", _html), do: value
  defp _get_prop_value(%{"datetime" => value}, "time", _html), do: value

  defp _get_prop_value(%{"href" => value}, tag, _html) when tag in ["a", "area", "link"],
    do: value

  defp _get_prop_value(%{"src" => value}, tag, _html)
       when tag in ["audio", "embed", "iframe", "img", "source", "track", "video"],
       do: value

  defp _get_prop_value(_attr_map, _tag, html), do: String.trim(HTML.text(html))
end
