defmodule EctoFragmentExtras.ConvertInlineParams do
  @moduledoc false

  def call({:<<>>, _meta, pieces}) do
    query =
      Enum.map_join(pieces, fn
        binary when is_binary(binary) -> binary
        _ -> "?"
      end)

    frags =
      Enum.flat_map(pieces, fn
        {:"::", _, [{_, _, [val]} | _]} -> [val]
        _ -> []
      end)

    {query, frags}
  end
end
