# EctoFragmentExtras

`EctoFragmentExtras` is a collection of macros to enhance Ecto's `fragment()` macro.

It adds the following variants which are all macros compiling into regular ecto fragments:

* `named_fragment("coalesce(#{:name}, #{:default})", name: user.name, default: ^default_name)`
* `inline_fragment("coalesce(#{user.name}, #{^default_name})")`

## Installation

Add `ecto_fragment_extras` to your list of dependencies in `mix.exs`:

    def deps do
      [{:ecto_fragment_extras, "~> 0.3.0"}]
    end

## Usage

### Named Params

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

### Inline Params

Instead of using Ectos `fragment` with ?-based interpolation, `inline_fragment` allows you to use inline params directly in your fragment query string.

`inline_fragment` is implemented as a macro on top of Ecto's `fragment` macro and, thus, as safe regarding SQL escaping.
Please note that it is only safe as long as the interpolation happens within the macro call.

So `inline_fragment("coalesce(#{1}, #{2})")` will be converted to `fragment("coalesce(?, ?, ?)", 1, 2)` at compile-time.

```elixir
defmodule TestQuery do
  import Ecto.Query
  import EctoFragmentExtras

  def test_query do
    default = "Jane Doe"
    query = from u in "users", select: inline_fragment("coalesce(#{u.name}, #{^default})")

    Repo.all(query)
  end
end
```

### `frag` - a helper combining both

`frag` is a shorthand which combines both (inline and named fragments) depending on the number of arguments
it is called with.
When called with just the query string, it interpolates like `inline_fragment/1`, when called
with an additional keyword list param it works like `named_fragment/2`.

## License

The entire project is under the MIT License. Please read [the LICENSE file](./LICENSE.md).

### Licensing

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, shall be licensed as above, without any additional terms or conditions.
