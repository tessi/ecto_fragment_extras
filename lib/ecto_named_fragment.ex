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
    use EctoNamedFragment

    def test_query do
      query = from u in "users",
              select: named_fragment("coalesce(:left, :right)", left: "example", right: "input")

      Repo.all(query)
    end
  end
  ```
  """
  alias EctoNamedFragment.ConvertToPositionedArgs

  defmacro __using__(_opts) do
    quote do
      @doc """
      An Ecto fragment() with named params.

      This macro converts a named-params fragment into the default Ecto
      fragment with positioned params.

      ```elixir
      named_fragment("coalesce(:left, :right)", left: "example", right: "input")
      ```

      into

      ```elixir
      fragment("coalesce(?, ?)", "example", "input")
      ```
      """
      defmacro named_fragment(query, args) when is_binary(query) and is_list(args) do
        case ConvertToPositionedArgs.call(query, args) do
          {:ok, query, args} ->
            quote do: fragment(unquote_splicing([query | args]))

          {:error, reason} ->
            raise "error converting named fragment: #{inspect(reason)}"
        end
      end
    end
  end
end
