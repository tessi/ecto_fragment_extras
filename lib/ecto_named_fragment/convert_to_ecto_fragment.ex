defmodule EctoNamedFragment.ConvertToEctoFragment do
  @moduledoc false

  import EctoNamedFragment.Exceptions, only: [error!: 1]

  def call({:<<>>, _, pieces}, params) do
    if not Keyword.keyword?(params) do
      error!(
        "named_fragment(...) expect a keyword list as the last argument, got: #{Macro.to_string(params)}"
      )
    end

    query =
      pieces
      |> Enum.map(fn
        "" <> binary -> binary
        _ -> "?"
      end)
      |> Enum.join()

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
