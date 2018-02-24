defmodule Midal.HTML do
  @default_parser Midal.HTML.Meeseeks
  @html_parser Application.get_env(:midal, :html_parser, @default_parser)

  @callback level_scopes(html :: String.t()) :: String.t()

  @callback level_props(html :: String.t()) :: String.t()

  @callback without_attribute(html :: String.t(), attr :: String.t()) :: String.t()

  @callback attribute(html :: String.t(), attr :: String.t()) :: String.t()

  @callback attributes(html :: String.t()) :: list({String.t(), String.t()})

  @callback text(html :: String.t()) :: String.t()

  @doc """
  Gives all the top level scopes.

  Note for anyone implementing this behavior - if you are using a CSS-based querying interface, this would be ideal:

  [itemscope]:not([itemscope] [itemscope])

  But as of this writing, W3 specifies that you cannot use descendant combinators inside the negation pseudoelement, only simple selectors are allowed.

  ## Examples

      iex> Midal.HTML.level_scopes("<section><div itemscope><div itemprop='name'>Midal</div></div><div itemscope><div itemprop='name'>Mida</div></div></section>")
      ["<div itemscope><div itemprop='name'>Midal</div></div>", "<div itemscope><div itemprop='name'>Mida</div></div>"]

  Nested scopes will not show up as a list element seperate from their parent scope

      iex> Midal.HTML.level_scopes("<section itemscope><div itemprop="library" itemscope><div itemprop='name'>Midal</div></div><div itemprop="library" itemscope><div itemprop='name'>Mida</div></div></section>")
      ["<section itemscope><div itemprop="library" itemscope><div itemprop='name'>Midal</div></div><div itemprop="library" itemscope><div itemprop='name'>Mida</div></div></section>"]

  """
  def level_scopes(html), do: @html_parser.level_scopes(html)

  def level_props(html), do: @html_parser.level_props(html)

  def tag(html), do: @html_parser.tag(html)

  def attribute(html, attr), do: @html_parser.attribute(html, attr)

  def attributes(html), do: @html_parser.attributes(html)

  def text(html), do: @html_parser.text(html)

  def without_attribute(html, attribute), do: @html_parser.without_attribute(html, attribute)
end
