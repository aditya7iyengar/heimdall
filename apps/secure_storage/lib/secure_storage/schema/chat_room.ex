defmodule SecureStorage.Schema.ChatRoom do
  @moduledoc """
  Schema for a Chat Room

  A chat room can allow text, audio and video
  """

  use SecureStorage.Schema

  # Last minute of y 2999 ~ infinity
  @default_exp_at ~U[2999-12-31 23:59:59Z]

  @castable_fields ~w(
    title
    allows_text
    allows_audio
    allows_video
    exp_at
    max_participants
  )a

  @required_fields ~w(
    title
    allows_text
    allows_audio
    allows_video
    exp_at
    max_participants
  )a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "chat_rooms" do
    # This is indexed
    field(:title, :string)

    # Modes of communication
    field(:allows_text, :boolean, default: true)
    field(:allows_audio, :boolean, default: true)
    field(:allows_video, :boolean, default: true)

    field(:exp_at, :utc_datetime, default: @default_exp_at)

    # Max number of participants allowed
    field(:max_participants, :integer, default: 5)

    # Stores information about a participant
    embeds_many :participants, Participant do
      field(:ip, :string)
      field(:name, :string)
      field(:joined_at, :utc_datetime)
    end

    timestamps()
  end

  @impl true
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @castable_fields)
    |> cast_embed(:participants, with: &participant_changeset/2)
    |> validate_required(@required_fields)
    |> validate_length(:title, max: 100)
  end

  defp participant_changeset(participant, params) do
    participant
    |> cast(params, [:ip, :name, :joined_at])
    |> validate_required([:ip, :name, :joined_at])
  end
end
