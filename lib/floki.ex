defmodule Midal.HTML.Floki do
  @behaviour Midal.HTML

  def parse(html) do
    parse_root_scopes(html)
  end

  defp parse_root_scopes(html, _map \\ %{}) do
    html
    |> get_root_scopes
    |> Enum.map(fn scope_html -> parse_props(scope_html) end)
  end

  defp get_root_scopes(html) do
    all_scopes = Floki.find(html, "[itemscope]")
    nested_scopes = Floki.find(html, "[itemscope] [itemscope]")
    all_scopes -- nested_scopes
  end

  defp parse_props(html) do
    (Floki.find(html, "[itemprop]") -- Floki.find(html, "[itemscope] [itemscope] [itemprop]"))
    |> get_prop_maps
    |> Enum.reduce(%{}, fn prop_map, map ->
      Map.merge(map, prop_map, fn _key, value, new_value ->
        handle_key_collision(value, new_value)
      end)
    end)
  end

  defp get_prop_maps(props) do
    props
    |> Enum.map(fn prop -> {Floki.attribute(prop, "itemprop"), get_prop_value(prop)} end)
    |> Enum.flat_map(fn {keys, value} -> for key <- keys, do: %{key => value} end)
  end

  defp handle_key_collision(value, new_value) when is_list(value) do
    [new_value | value]
  end

  defp handle_key_collision(value, new_value) do
    [new_value, value]
  end

  defp get_prop_value(html = {element, attrs, _prop_html}) do
    attrs
    |> Enum.into(%{})
    |> _get_prop_value(element, html)
  end

  defp _get_prop_value(%{"itemscope" => _}, _, {element, attrs, html}) do
    cleaned_attrs = Enum.filter(attrs, fn {attribute, _value} -> attribute != "itemprop" end)
    Enum.at(parse_root_scopes({element, cleaned_attrs, html}), 0)
  end

  defp _get_prop_value(%{"content" => value}, _, _), do: value
  defp _get_prop_value(%{"value" => value}, "data", _), do: value
  defp _get_prop_value(%{"value" => value}, "meter", _), do: value
  defp _get_prop_value(%{"datetime" => value}, "time", _), do: value
  defp _get_prop_value(%{"href" => value}, _, _), do: value
  defp _get_prop_value(%{"src" => value}, _, _), do: value
  defp _get_prop_value(_, _, html), do: String.trim(Floki.text(html))
end
