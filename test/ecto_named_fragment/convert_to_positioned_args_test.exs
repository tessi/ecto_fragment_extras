defmodule ConvertToPositionedArgsTest do
  use ExUnit.Case

  alias EctoNamedFragment.ConvertToPositionedArgs

  test "converts name-args fragment string to positioned-args form" do
    assert ConvertToPositionedArgs.call("coalesce(:left, :right)", %{"left" => 1, "right" => 2}) ==
             {:ok, "coalesce(?, ?)", [1, 2]}
  end

  test "using an argument more than once" do
    assert ConvertToPositionedArgs.call(":a + :b + :a", %{"a" => 1, "b" => 2}) ==
             {:ok, "? + ? + ?", [1, 2, 1]}
  end

  test "errors with missing arg" do
    assert ConvertToPositionedArgs.call("coalesce(:left, :right)", %{"left" => 1}) ==
             {:error, "missing argument `right` in fragment"}
  end

  test "escaped colon" do
    assert ConvertToPositionedArgs.call("coalesce(:left, \\:right)", %{"left" => 1}) ==
             {:ok, "coalesce(?, :right)", [1]}
  end
end
