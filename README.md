# Midal

A microdata parser for Elixir. Name shamelessly stolen from
[Mida](https://github.com/lawrencewoodman/mida). Lots of changes are incoming
so consider the parse interface unstable.

## Example usage

```elixir

  iex> Midal.parse("<div itemscope><div itemprop='name'>Midal</div></div>")
  {:ok, %{"name" => "Midal"}}

```

## Deviations from W3C spec

Any deviation from [the current specification](https://www.w3.org/TR/microdata/) is considered a bug. Here are the currently known limitations:

 * Unsupported attributes:
   - `itemref`
   - `itemtype`


## TODOs

- [x] implement initial basic parser
- [ ] fix deviations from w3c spec
- [ ] improve Floki-based implementation (horrific performance, requeries the document way too much)
- [ ] write conversion utilities for JSON-LD, RDFa
- [ ] research adding features for vocabularies (validation, not sure what else is useful)
- [ ] setup CI
- [ ] general repo maintenance (contributors, issue templates, etc)
- [ ] publish on hex when stable

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

