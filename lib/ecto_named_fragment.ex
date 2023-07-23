defmodule EctoNamedFragment do
  alias EctoNamedFragment.ConvertToEctoFragment

  @moduledoc """
  `EctoNamedFragment` is a library for using named-params in Ecto fragments.

  Instead of using Ectos `fragment` with ?-based interpolation, `named_fragment`
  allows you to use named params in your fragments.

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
  """
  defmacro named_fragment(query, params) when is_list(params) do
    {query, frags} = ConvertToEctoFragment.call(query, params)

    quote do
      fragment(unquote(query), unquote_splicing(frags))
    end
  end
end
