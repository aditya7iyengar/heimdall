defmodule SecureStorage.Repo.Migrations.CreateEncryptedMessages do
  use Ecto.Migration

  def change do
    create table(:encrypted_messages, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :short_description, :string, null: false, size: 100

      add :description, :string

      add :password_hint, :string

      add :encryption_algo, :string, default: "aes_gcm"

      add :txt, :string

      add :max_attempts, :integer, default: 999

      add :max_reads, :integer, default: 999

      add :enc_at, :utc_datetime

      add :exp_at, :utc_datetime

      add :state, :string, default: "new"

      add :attempts, {:array, :map}, default: []

      add :reads, {:array, :map}, defaults: []

      timestamps()
    end

    # For searching
    create index(:encrypted_messages, [:short_description])

    # For data sweeping
    create index(:encrypted_messages, [:state])
  end
end
