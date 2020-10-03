defmodule HeimdallQL.Schema do
  @moduledoc """
  Main Absinthe Schema for Heimdall
  """

  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(HeimdallQL.Schema.Aesir)

  def context(ctx), do: ctx

  def plugins do
    Absinthe.Plugin.defaults()
  end

  query do
    import_fields(:aesir_queries)
  end
end
