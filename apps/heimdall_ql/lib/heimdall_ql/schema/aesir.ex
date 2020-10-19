defmodule HeimdallQL.Schema.Aesir do
  @moduledoc """
  GrapqhQL queries and objects for Aesir
  """

  use Absinthe.Schema.Notation

  alias HeimdallQL.Resolver

  object :aesir_queries do
    @desc "List Aesirs"
    field :aesirs, list_of(:aesir) do
      resolve(&Resolver.list_aesirs/3)
    end

    @desc "Get Aesir"
    field :aesir, :aesir do
      arg(:uuid, non_null(:string))

      resolve(&Resolver.get_aesir/3)
    end
  end

  object :aesir_mutations do
    @desc "Create Aesir"
    field :create_aesir, type: :aesir do
      arg(:raw, non_null(:string))
      arg(:key, non_null(:string))
      arg(:description, non_null(:string))
      arg(:encryption_algo, :string)
      arg(:ttl, :integer)
      arg(:max_attempts, :integer)
      arg(:max_decryptions, :integer)

      resolve(&Resolver.create_aesir/3)
    end
  end

  object :aesir do
    field(:description, :string)
    field(:encrypted, :string)
    field(:encryption_algo, :string)
    field(:exp, :datetime)
    field(:iat, :datetime)
    field(:uuid, :string)
    field(:current_attempts, :integer)
    field(:max_attempts, :integer)
    field(:current_encryptions, :integer)
    field(:max_encryptions, :integer)
  end
end
