# EctoNamedFragment

`EctoNamedFragment` is a library for using named-params in Ecto fragments.

## Installation

Add `ecto_named_fragment` to your list of dependencies in `mix.exs`:

    def deps do
      [{:ecto_named_fragment, "~> 0.2.0"}]
    end

## Usage

Instead of using Ectos `fragment` with ?-based interpolation, `named_fragment` allows you to use named params in your fragments.

`named_fragment` is implemented as a macro on top of Ecto's `fragment` macro.

So `named_fragment("coalesce(#{:a}, #{:b}, #{:a})", a: 1, b: 2)` will
be converted to `fragment("coalesce(?, ?, ?)", 1, 2, 1)` at compile-time.

```elixir
defmodule TestQuery do
  import Ecto.Query
  import EctoNamedFragment

  def test_query do
    query = from u in "users",
            select: named_fragment("coalesce(#{:left}, #{:right})", left: "example", right: "input")

    Repo.all(query)
  end
end
```

## License

The entire project is under the MIT License. Please read [the LICENSE file](./LICENSE.md).

### Licensing

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, shall be licensed as above, without any additional terms or conditions.
