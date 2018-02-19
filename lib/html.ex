defmodule Midal.HTML do
  @html_parser Application.get_env(:midal, :html_parser)

  @callback parse(html :: String.t()) :: {:ok, String.t()} | {:error | String.t()}

  def parse(html) do
    @html_parser.parse(html)
  end
end
