defmodule Midal do
  import Midal.HTML

  @moduledoc """
  A microdata parser for Elixir.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Midal.parse("<div itemscope><div itemprop='name'>Midal</div></div>")
      [%{"name" => "Midal"}]

  """
  def parse(html) when is_bitstring(html) do
    parse_root_scopes(html)
  end

  defp parse_root_scopes(html) do
    html
    |> level_scopes
    |> Enum.map(&level_props/1)
    |> Enum.map(&parse_props/1)
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
    |> Enum.map(fn prop -> {attribute(prop, "itemprop"), get_prop_value(prop)} end)
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
    attributes(html)
    |> Enum.into(%{})
    |> _get_prop_value(tag(html), html)
  end

  defp _get_prop_value(%{"itemscope" => _}, _tag, html) do
    Enum.at(parse_root_scopes(without_attribute(html, "itemprop")), 0)
  end

  defp _get_prop_value(%{"content" => value}, _tag, _html), do: value
  defp _get_prop_value(%{"value" => value}, "data", _html), do: value
  defp _get_prop_value(%{"value" => value}, "meter", _html), do: value
  defp _get_prop_value(%{"datetime" => value}, "time", _html), do: value
  defp _get_prop_value(%{"href" => value}, tag, _html) when tag in ["a", "area", "link"], do: value
  defp _get_prop_value(%{"src" => value}, tag, _html) when tag in ["audio", "embed", "iframe", "img", "source", "track", "video"], do: value
  defp _get_prop_value(_attr_map, _tag, html), do: String.trim(text(html))
end
