defmodule SecureStorage.Repo.Migrations.CreateChatRooms do
  use Ecto.Migration

  def change do
    create table(:chat_rooms, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :title, :string, null: false, size: 100

      add :allows_text, :boolean, default: true
      add :allows_audio, :boolean, default: true
      add :allows_video, :boolean, default: true

      add :exp_at, :utc_datetime

      add :max_participants, :integer, default: 5

      add :participants, {:array, :map}, default: []

      timestamps()
    end

    create index(:chat_rooms, [:title])
  end
end
