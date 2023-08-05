defmodule EctoFragmentExtrasTest do
  use ExUnit.Case, async: true
  doctest EctoFragmentExtras

  import Ecto.Query
  import EctoFragmentExtras

  describe "named_fragment/2" do
    test "expands named params into a regular ecto fragment" do
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

    test "interpolating repeated params" do
      query = from(u in "users", select: named_fragment("foo(#{:a}, #{:a})", a: u.name))

      assert inspect(query) ==
               "#Ecto.Query<from u0 in \"users\", select: fragment(\"foo(?, ?)\", u0.name, u0.name)>"
    end
  end

  describe "inline_fragment/1" do
    test "expands inline params into a regular ecto fragment" do
      default_name = "pin"
      query = from(u in "users", select: inline_fragment("coalesce(#{u.name}, #{^default_name})"))

      assert inspect(query) ==
               "#Ecto.Query<from u0 in \"users\", select: fragment(\"coalesce(?, ?)\", u0.name, ^\"pin\")>"
    end
  end

  describe "frag/1 && frag/2 combined inline_fragment/1 and named_fragment/2" do
    test "expands named params into a regular ecto fragment" do
      default_name = "pin"

      query =
        from(u in "users",
          select:
            frag(
              "coalesce(#{:name}, #{:default_name})",
              name: u.name,
              default_name: ^default_name
            )
        )

      assert inspect(query) ==
               "#Ecto.Query<from u0 in \"users\", select: fragment(\"coalesce(?, ?)\", u0.name, ^\"pin\")>"
    end

    test "expands inline params into a regular ecto fragment" do
      default_name = "pin"
      query = from(u in "users", select: frag("coalesce(#{u.name}, #{^default_name})"))

      assert inspect(query) ==
               "#Ecto.Query<from u0 in \"users\", select: fragment(\"coalesce(?, ?)\", u0.name, ^\"pin\")>"
    end
  end
end
