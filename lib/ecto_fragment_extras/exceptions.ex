defmodule EctoFragmentExtras.Exceptions do
  defmodule CompileError do
    @moduledoc """
    Raised at compilation time when the named fragment cannot be compiled.
    """
    defexception [:message]
  end

  def error!(message) when is_binary(message) do
    {:current_stacktrace, [_ | t]} = Process.info(self(), :current_stacktrace)

    t =
      Enum.drop_while(t, fn
        {mod, _, _, _} ->
          String.starts_with?(Atom.to_string(mod), ["Elixir.EctoFragmentExtras."])

        _ ->
          false
      end)

    reraise CompileError, [message: message], t
  end
end
