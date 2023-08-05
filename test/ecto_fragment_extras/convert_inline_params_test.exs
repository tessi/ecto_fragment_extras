defmodule ConvertInlineParamsTest do
  use ExUnit.Case, async: true
  doctest EctoFragmentExtras

  alias EctoFragmentExtras.ConvertInlineParams

  test "building a fragment query string and splits params" do
    assert ConvertInlineParams.call(
             quote do
               "foo(#{0}, #{1})"
             end
           ) ==
             {"foo(?, ?)", [0, 1]}
  end
end
