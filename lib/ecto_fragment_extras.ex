defmodule EctoFragmentExtras do
  @moduledoc ~S"""
  `EctoFragmentExtras` is a collection of macros to enhance Ecto fragments.

  Instead of using Ectos `fragment` with ?-based interpolation, this module
  provides macros (that expand into regular Ecto fragments) which allow
  named or inline params.
  """

  alias EctoFragmentExtras.ConvertInlineParams
  alias EctoFragmentExtras.ConvertNamedParams

  @doc """
  A variant of Ecto fragment() which supports named params.

  Nameds params are provided in a keyword list as the last argument.
  The fragments query string can reference named params using the
  `#{:name}` syntax where `name` is a key in the keyword list.

  So `named_fragment("coalesce(#{:a}, #{:b}, #{:a})", a: 1, b: 2)` will
  be expanded to `fragment("coalesce(?, ?, ?)", 1, 2, 1)` at compile-time.

  ```elixir
  defmodule TestQuery do
    import Ecto.Query
    import EctoFragmentExtras

    def test_query do
      default = "Jane Doe"
      query = from users in "users",
              select: named_fragment("coalesce(#{:a}, #{:b})", a: users.name, b: ^default)

      Repo.all(query)
    end
  end
  ```
  """
  defmacro named_fragment(query, params) when is_list(params) do
    {query, frags} = ConvertNamedParams.call(query, params)

    quote do
      fragment(unquote(query), unquote_splicing(frags))
    end
  end

  @doc ~S"""
  A variant of Ecto fragment() which supports params inlined in the query string.

  Inline params are provided within the fragment query string as
  `#{}`-style string interpolation. Since this is a macro which expands to a regular
  Ecto fragment, those interpolations are safe (they are no real string interpolations,
  and pose no extra SQL injection risk compared to regular fragments).

  So `inline_fragment("coalesce(#{user.name}, #{^default})")` will
  be expanded to `fragment("coalesce(?, ?)", user.name, ^default)` at compile-time.

  ```elixir
  defmodule TestQuery do
    import Ecto.Query
    import EctoFragmentExtras

    def test_query do
      default = "Jane Doe"
      query = from users in "users",
              select: inline_fragment("coalesce(#{users.name}, #{^default})")

      Repo.all(query)
    end
  end
  ```

  SAFETY WARNING: Please note that it is NOT safe to first interpolate a string which is passed in to this macro.
  Unsafe example:

  ```elixir
  def unsafe_query(user_name) do
      default = "Jane Doe"
      fragment_string = "coalesce(#{user_name}, #{^default})"
      query = from users in "users",
              select: inline_fragment(fragment_string)

      Repo.all(query)
    end
  end
  ```

  The code above is UNSAFE, because the interpolation is done before the macro is called and the macro
  receives the already interpolated string. This prohibits the macro from safely escaping the query params.
  If the `user_name` param comes from untrusted user input, this can lead to SQL injection.
  """
  defmacro inline_fragment(query) do
    {query, frags} = ConvertInlineParams.call(query)

    quote do
      fragment(unquote(query), unquote_splicing(frags))
    end
  end

  @doc ~S"""
  A variant of Ecto fragment() which supports params inlined in the query string or named params depending on the number of arguments.

  When called with only a query string, this macro behaves like `inline_fragment/1`.
  When called with a query string and a keyword list, this macro behaves like `named_fragment/2`.

  ```elixir
  defmodule TestQuery do
    import Ecto.Query
    import EctoFragmentExtras

    @default_name "Jane Doe"

    def test_query_named do
      query = from users in "users",
              select: frag("coalesce(#{:a}, #{:b})", a: users.name, b: ^@default_name)

      Repo.all(query)
    end

    def test_query_inline do
      query = from users in "users",
              select: frag("coalesce(#{users.name}, #{^@default_name})")

      Repo.all(query)
    end
  end
  ```
  """
  defmacro frag(query) do
    quote do
      inline_fragment(unquote(query))
    end
  end

  defmacro frag(query, params) do
    quote do
      named_fragment(unquote(query), unquote(params))
    end
  end
end
