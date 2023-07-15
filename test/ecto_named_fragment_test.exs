defmodule EctoNamedFragmentTest do
  use ExUnit.Case
  doctest EctoNamedFragment

  defmodule Example do
    import Ecto.Query
    use EctoNamedFragment

    def query(default_name) do
      from(u in "users",
        select:
          named_fragment(
            "coalesce(:name, :default_name)",
            name: u.name,
            default_name: ^default_name
          )
      )
    end
  end

  test "allows a module to use the named_fragment macro" do
    query = Example.query("pin")

    assert inspect(query) ==
             "#Ecto.Query<from u0 in \"users\", select: fragment(\"coalesce(?, ?)\", u0.name, ^\"pin\")>"
  end
end
