defmodule HeimdallQL.Schema.EncryptedMessage do
  @moduledoc """
  GrapqhQL queries and objects for EncryptedMessage
  """

  use Absinthe.Schema.Notation

  alias HeimdallQL.Resolver

  object :encrypted_message_queries do
    @desc "List EncryptedMessages"
    field :encrypted_messages, list_of(:encrypted_message) do
      resolve(&Resolver.list_encrypted_messages/3)
    end

    @desc "Get EncryptedMessage"
    field :encrypted_message, :encrypted_message do
      arg(:id, non_null(:string))

      resolve(&Resolver.get_encrypted_message/3)
    end
  end

  object :encrypted_message_mutations do
    @desc "Create EncryptedMessage"
    field :create_encrypted_message, type: :encrypted_message do
      arg(:raw, non_null(:string))
      arg(:key, non_null(:string))
      arg(:short_description, non_null(:string))
      arg(:description, :string)
      arg(:password_hint, :string)
      arg(:encryption_algo, :string)
      arg(:ttl, :integer)
      arg(:max_attempts, :integer)
      arg(:max_decryptions, :integer)

      resolve(&Resolver.create_encrypted_message/3)
    end
  end

  object :encrypted_message do
    field(:id, :string)

    field(:short_description, :string)
    field(:description, :string)
    field(:password_hint, :string)

    field(:encryption_algo, :string)
    field(:txt, :string)

    field(:max_attempts, :integer)
    field(:max_reads, :integer)

    field(:enc_at, :datetime)
    field(:exp_at, :datetime)

    field(:state, :string)

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
  end
end
