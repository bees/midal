# Midal

A microdata parser for Elixir.


## Example usage

```elixir

  iex> Midal.parse("<div itemscope><div itemprop="name">Midal</div></div>")
  {:ok, %{"name" => "Midal"}}

```

## TODOs

- [ ] implement initial basic parser
- [ ] add unit tests
- [ ] abstract use of HTML parser
- [ ] write conversion utilities for JSON-LD, RDFa
- [ ] Research adding features for vocabularies (validation, not sure what else is useful)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `midal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:midal, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/midal](https://hexdocs.pm/midal).

