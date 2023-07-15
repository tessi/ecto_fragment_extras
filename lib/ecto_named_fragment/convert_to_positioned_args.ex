defmodule EctoNamedFragment.ConvertToPositionedArgs do
  alias EctoNamedFragment.FragmentQueryParser

  def call(query, args) when is_list(args) do
    args =
      args
      |> Enum.map(fn {k, v} -> {to_string(k), v} end)
      |> Enum.into(%{})

    call(query, args)
  end

  def call(query, args) when is_map(args) do
    with {:ok, matched, "", _, _, _} = FragmentQueryParser.fragment_query(query),
         {:ok, query, params_reversed} <- reduce_matched_parts(matched, args) do
      {:ok, query, Enum.reverse(params_reversed)}
    else
      {:error, reason, _rest, _context, _line, _byte_offset} ->
        {:error, reason}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp reduce_matched_parts(parts, args) do
    Enum.reduce_while(parts, {:ok, "", []}, fn part, {:ok, query, params} ->
      case part do
        part when is_binary(part) ->
          {:cont, {:ok, query <> part, params}}

        {:arg, [name]} ->
          case Map.get(args, name) do
            nil ->
              {:halt, {:error, "missing argument `#{name}` in fragment"}}

            value ->
              {:cont, {:ok, query <> "?", [value | params]}}
          end
      end
    end)
  end
end
