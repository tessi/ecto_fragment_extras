ExUnit.start()

defmodule EctoFragmentExtrasConsumerTest do
  use ExUnit.Case, async: true

  import Ecto.Query
  import EctoFragmentExtras

  test "all four public macros produce the same select expression and bindings as Ecto" do
    default_name = "Jane Doe"

    native =
      from(user in "users",
        select: fragment("coalesce(?, ?, ?)", user.name, ^default_name, user.name)
      )

    named =
      from(user in "users",
        select:
          named_fragment("coalesce(#{:name}, #{:default}, #{:name})",
            default: ^default_name,
            name: user.name
          )
      )

    inline =
      from(user in "users",
        select: inline_fragment("coalesce(#{user.name}, #{^default_name}, #{user.name})")
      )

    short_named =
      from(user in "users",
        select:
          frag("coalesce(#{:name}, #{:default}, #{:name})",
            default: ^default_name,
            name: user.name
          )
      )

    short_inline =
      from(user in "users",
        select: frag("coalesce(#{user.name}, #{^default_name}, #{user.name})")
      )

    for query <- [named, inline, short_named, short_inline] do
      assert query.select.expr == native.select.expr
      assert query.select.params == native.select.params
    end
  end
end
