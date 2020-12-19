defmodule SecureStorage.SweeperTest do
  use SecureStorage.DataCase

  alias SecureStorage.Repo
  alias SecureStorage.Schema.EncryptedMessage

  @module SecureStorage.Sweeper

  describe "run/0" do
    setup do
      expired_message =
        %EncryptedMessage{state: :expired, short_description: "desc"}
        |> EncryptedMessage.changeset(%{txt: "txt", enc_at: DateTime.utc_now()})
        |> Repo.insert!()

      no_attempts_left_message =
        %EncryptedMessage{state: :no_attempts_left, short_description: "desc"}
        |> EncryptedMessage.changeset(%{txt: "txt", enc_at: DateTime.utc_now()})
        |> Repo.insert!()

      no_reads_left_message =
        %EncryptedMessage{state: :no_reads_left, short_description: "desc"}
        |> EncryptedMessage.changeset(%{txt: "txt", enc_at: DateTime.utc_now()})
        |> Repo.insert!()

      new_message =
        %EncryptedMessage{state: :new, short_description: "desc"}
        |> EncryptedMessage.changeset(%{})
        |> Repo.insert!()

      {
        :ok,
        expired_message: expired_message,
        no_attempts_left_message: no_attempts_left_message,
        no_reads_left_message: no_reads_left_message,
        new_message: new_message
      }
    end

    test "deletes only messages with stale states", context do
      %{
        expired_message: expired_message,
        no_attempts_left_message: no_attempts_left_message,
        no_reads_left_message: no_reads_left_message,
        new_message: new_message
      } = context

      @module.run()

      messages = Repo.all(EncryptedMessage)

      refute expired_message in messages
      refute no_attempts_left_message in messages
      refute no_reads_left_message in messages

      assert new_message in messages
    end
  end
end
