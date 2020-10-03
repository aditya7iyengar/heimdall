defmodule HeimdallQL.AbsintheCase do
  @moduledoc false

  defmacro __using__(opts) do
    quote do
      use ExUnit.Case, unquote(opts)

      defdelegate run(document, schema, options \\ []), to: Absinthe
    end
  end
end
