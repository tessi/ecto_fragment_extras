defmodule ConvertToEctoFragmentTest do
  use ExUnit.Case
  doctest EctoNamedFragment

  alias EctoNamedFragment.ConvertToEctoFragment
  alias EctoNamedFragment.Exceptions.CompileError

  test "builds a fragment query string and splits params from kw list" do
    assert ConvertToEctoFragment.call(
             quote do
               "foo(#{:a}, #{:b})"
             end,
             a: 0,
             b: 1
           ) ==
             {"foo(?, ?)", [0, 1]}
  end

  test "allows repeated param names" do
    assert ConvertToEctoFragment.call(
             quote do
               "foo(#{:a}, #{:b}, #{:a})"
             end,
             a: 0,
             b: 1
           ) ==
             {"foo(?, ?, ?)", [0, 1, 0]}
  end

  test "raises for unknown params" do
    assert_raise KeyError,
                 "key :b not found in: [a: 0]",
                 fn ->
                   ConvertToEctoFragment.call(
                     quote do
                       "foo(#{:a}, #{:b})"
                     end,
                     a: 0
                   )
                 end
  end

  test "raises on non-atom names" do
    assert_raise CompileError,
                 "names in named_fragment(...) queries must be atoms, got: a",
                 fn ->
                   ConvertToEctoFragment.call(
                     quote do
                       "foo(#{a})"
                     end,
                     a: 0
                   )
                 end
  end

  test "raises on non-kw name lists" do
    assert_raise CompileError,
                 "named_fragment(...) expect a keyword list as the last argument, got: [\"a\"]",
                 fn ->
                   ConvertToEctoFragment.call(
                     quote do
                       "foo(#{:a})"
                     end,
                     ["a"]
                   )
                 end
  end
end
