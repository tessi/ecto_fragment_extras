defmodule EctoNamedFragmentTest do
  use ExUnit.Case
  doctest EctoNamedFragment

  import Ecto.Query
  import EctoNamedFragment

  test "allows named params interpolation through the named_fragment macro" do
    default_name = "pin"

    query =
      from(u in "users",
        select:
          named_fragment(
            "coalesce(#{:name}, #{:default_name})",
            name: u.name,
            default_name: ^default_name
          )
      )

    assert inspect(query) ==
             "#Ecto.Query<from u0 in \"users\", select: fragment(\"coalesce(?, ?)\", u0.name, ^\"pin\")>"
  end

  test "allows repeated params" do
    query = from(u in "users", select: named_fragment("foo(#{:a}, #{:a})", a: u.name))

    assert inspect(query) ==
             "#Ecto.Query<from u0 in \"users\", select: fragment(\"foo(?, ?)\", u0.name, u0.name)>"
  end
end
