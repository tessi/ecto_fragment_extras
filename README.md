# EctoFragmentExtras

`EctoFragmentExtras` is a collection of extensions to enhance Ecto's fragment() macro.

It adds the following fragment variants which are all macros compiling into regular ecto fragments:

* `named_fragment("coalesce(#{:name}, #{:default})", name: user.name, default: ^default_name)`
* `inline_fragment("coalesce(#{user.name}, #{^default_name})")`

## Installation

Add `ecto_fragment_extras` to your list of dependencies in `mix.exs`:

    def deps do
      [{:ecto_fragment_extras, "~> 0.3.0"}]
    end

## Usage

### Fragments with named params

Instead of using Ectos `fragment` with ?-based interpolation, `named_fragment` allows you to use named params in your fragments.

`named_fragment` is implemented as a macro on top of Ecto's `fragment` macro.

So `named_fragment("coalesce(#{:a}, #{:b}, #{:a})", a: 1, b: 2)` will
be converted to `fragment("coalesce(?, ?, ?)", 1, 2, 1)` at compile-time.

```elixir
defmodule TestQuery do
  import Ecto.Query
  import EctoFragmentExtras

  def test_query do
    query = from u in "users",
            select: named_fragment("coalesce(#{:left}, #{:right})", left: "example", right: "input")

    Repo.all(query)
  end
end
```

## TODO (removed before release)

* ~FRAG("FOO(?{table.a}, ?{^other})") alias ~FRAGMENT
* remove old hex package, publish new one
* docs, readme, changelog

## License

The entire project is under the MIT License. Please read [the LICENSE file](./LICENSE.md).

### Licensing

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, shall be licensed as above, without any additional terms or conditions.
