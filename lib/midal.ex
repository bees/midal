defmodule Midal do
  @moduledoc """
  A microdata parser for Elixir.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Midal.parse("<div itemscope><div itemprop="name">Midal</div></div>")
      %{"name" => "Midal"}

  """
  def parse!(html) when is_bitstring(html) do
    :world
  end
end
