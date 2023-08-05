defmodule EctoFragmentExtras.ConvertNamedParams do
  @moduledoc false

  import EctoFragmentExtras.Exceptions, only: [error!: 1]

  def call({:<<>>, _meta, pieces}, params) do
    if not Keyword.keyword?(params) do
      error!(
        "named_fragment(...) expect a keyword list as the last argument, got: #{Macro.to_string(params)}"
      )
    end

    query =
      Enum.map_join(pieces, fn
        binary when is_binary(binary) -> binary
        _ -> "?"
      end)

    frags =
      Enum.flat_map(pieces, fn
        {:"::", _, [{_, _, [val]} | _]} when is_atom(val) ->
          [Keyword.fetch!(params, val)]

        {:"::", _, [{_, _, [val]} | _]} ->
          error!(
            "names in named_fragment(...) queries must be atoms, got: #{Macro.to_string(val)}"
          )

        _ ->
          []
      end)

    {query, frags}
  end
end
