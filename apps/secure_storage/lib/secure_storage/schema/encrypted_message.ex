defmodule SecureStorage.Schema.EncryptedMessage do
  @moduledoc """
  Schema for an encrypted message

  # States
    - New: EncryptedMessage created but has no significance
    - Pending: EncryptedMessage waiting for encryption (Used for incoming)
    - Encryption Failed: Failed to encrypted message
    - Encrypted: Message encrypted and ready for decryption
    - Expired: Beyond exp_at
    - No attempts left: All attempts used
    - No reads left: All reads used
  """

  use SecureStorage.Schema

  # Last minute of y 2999 ~ infinity
  @default_exp_at ~U[2999-12-31 23:59:59Z]

  @encryption_algos ~w(
    plain
    aes_gcm
  )a

  @states ~w(
    new
    pending
    encryption_failed
    encrypted
    expired
    no_attempts_left
    no_reads_left
  )a

  @castable_fields ~w(
    short_description
    description
    password_hint
    encryption_algo
    txt
    max_attempts
    max_reads
    enc_at
    exp_at
    state
  )a

  @required_fields ~w(
    short_description
    password_hint
    txt
    enc_at
    exp_at
  )a

  schema "encrypted_messages" do
    # This is for searching and is indexed
    field(:short_description, :string)

    # Bigger non-indexed description
    field(:description, :string)

    # Password hint for decryption
    field(:password_hint, :string)

    # Algorithm used to encrypt the message
    field(:encryption_algo, Ecto.Enum,
      values: @encryption_algos,
      default: :aes_gcm
    )

    # Encrypted text
    field(:txt, :string)

    # Max unsuccessful decryption attempts
    field(:max_attempts, :integer, default: 999)

    # Max number of times decrypted and read
    field(:max_reads, :integer, default: 999)

    # Timestamps for encrypted at and expiration at
    field(:enc_at, :utc_datetime)
    field(:exp_at, :utc_datetime, default: @default_exp_at)

    # State of the message
    field(:state, Ecto.Enum, values: @states, default: :new)

    # Stores information regarding unsuccessful attempts
    embeds_many :attempts, Attempt do
      field(:ip, :string)
      field(:at, :utc_datetime)
      field(:failure_reason, :string)
    end

    # Stores information regarding reads
    embeds_many :reads, Read do
      field(:ip, :string)
      field(:at, :utc_datetime)
    end

    timestamps()
  end

  @impl true
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @castable_fields)
    |> cast_embed(:attempts, with: &attempt_changeset/2)
    |> cast_embed(:reads, with: &read_changeset/2)
    |> validate_required(@required_fields)
    |> validate_inclusion(:state, @states)
    |> validate_inclusion(:encryption_algo, @encryption_algos)
    |> validate_length(:short_description, max: 100)
  end

  defp attempt_changeset(attempt, params) do
    attempt
    |> cast(params, [:ip, :at, :failure_reason])
    |> validate_required([:ip, :at, :failure_reason])
  end

  defp read_changeset(read, params) do
    read
    |> cast(params, [:ip, :at])
    |> validate_required([:ip, :at])
  end
end
