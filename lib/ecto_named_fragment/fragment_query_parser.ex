defmodule EctoNamedFragment.FragmentQueryParser do
  @moduledoc false

  import NimbleParsec

  arg_name =
    ignore(string(":"))
    |> repeat(ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1))
    |> tag(:arg)

  escape = ignore(string("\\")) |> string(":")
  fragment_query = repeat(choice([escape, arg_name, utf8_string([not: ?:], 1)]))

  defparsec(:fragment_query, fragment_query |> eos() |> post_traverse({:join, []}))

  defp join(rest, args, context, _line, _offset) do
    {rest, join_strings(args), context}
  end

  defp join_strings([]), do: []
  defp join_strings([a]), do: [a]

  defp join_strings([a | [b | rest]]) when is_binary(a) and is_binary(b),
    do: join_strings([b <> a | rest])

  defp join_strings([a | [b | rest]]), do: [a | join_strings([b | rest])]
end
