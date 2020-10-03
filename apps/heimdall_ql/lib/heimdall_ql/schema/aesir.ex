defmodule HeimdallQL.Schema.Aesir do
  @moduledoc """
  GrapqhQL queries and objects for Aesir
  """

  use Absinthe.Schema.Notation

  alias HeimdallQL.Resolver

  object :aesir_queries do
    @desc "List Aesirs"
    field :aesir, list_of(:aesir) do
      resolve(&Resolver.list_aesirs/3)
    end
  end

  object :aesir do
    field(:description, :string)
    field(:encrypted, :string)
    field(:encryption_algo, :string)
    field(:uuid, :string)
    field(:iat, :datetime)
    field(:exp, :datetime)
  end
end
