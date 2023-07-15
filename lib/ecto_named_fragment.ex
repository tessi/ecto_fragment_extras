defmodule EctoNamedFragment do
  @moduledoc """
  `EctoNamedFragment` is a library for using named-params in Ecto fragments.

  Instead of using Ectos `fragment` with ?-based interpolation, `named_fragment`
  allows you to use named params in your fragments.

  `named_fragment` is implemented as a macro on top of Ecto's `fragment` macro.

  So `named_fragment("coalesce(:a, :b, :a)", a: 1, b: 2)` will
  be converted to `fragment("coalesce(?, ?, ?)", 1, 2, 1)` at compile-time.

  To use the `named_fragment` macro, `use EctoNamedFragment` in your module:

  ```elixir
  defmodule TestQuery do
    import Ecto.Query
    import EctoNamedFragment

    def test_query do
      left = 1
      right = 2

      query = from u in "users",
        select: named_fragment("coalesce(:left, :right)", left: left, right: right)

      Repo.all(query)
    end
  end
  """
  alias EctoNamedFragment.ConvertToPositionedArgs

  defmacro __using__(_opts) do
    quote do
      @doc """
      An Ecto fragment() with named params.

      This macro converts a named-params fragment into the default Ecto
      fragment with positioned params.

      ```elixir
      frag("coalesce(:left, :right)", left: left, right: right)
      ```

      into

      ```elixir
      fragment("coalesce(?, ?)", left, right)
      ```

      This conversion is done at compile-time (d'oh! it's a macro, right :)).
      Thus, it's not possible to dynamically create the query-string at runtime.
      """
      defmacro named_fragment(query, args) when is_binary(query) and is_list(args) do
        with {:ok, query, args} <- ConvertToPositionedArgs.call(query, args) do
          quote do
            fragment(unquote_splicing([query | args]))
            # apply(unquote(__CALLER__.module), :fragment, [unquote(query) | unquote(args)])
          end
        else
          {:error, reason} ->
            raise "error converting named fragment: #{inspect(reason)}"
        end
      end
    end
  end
end
