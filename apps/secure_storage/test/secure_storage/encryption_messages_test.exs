defmodule SecureStorage.EncryptedMessagesTest do
  use SecureStorage.DataCase

  alias SecureStorage.Repo
  alias SecureStorage.Schema.EncryptedMessage

  @module SecureStorage.EncryptedMessages

  describe "insert_new_message/1" do
    test "successfully inserts when params are valid" do
      short_description = "short desc"

      valid_params = %{
        "short_description" => short_description
      }

      {:ok, encrypted_message} = @module.insert_new_message(valid_params)

      assert encrypted_message.state == :new
      assert encrypted_message.short_description == short_description
    end

    test "returns invalid changeset when invalid params" do
      invalid_params = %{}

      {:error, changeset} = @module.insert_new_message(invalid_params)

      refute changeset.valid?
    end
  end

  describe "insert_encrypted_message/1" do
    test "successfully inserts when params are valid" do
      ttl = 2
      short_description = "short desc"

      valid_params = %{"short_description" => short_description, "ttl" => ttl}

      raw = "Raw text"
      key = "key"

      {:ok, message} = @module.insert_encrypted_message(raw, key, valid_params)

      assert message.short_description == short_description
      assert message.state == :encrypted
      assert message.txt != raw
      assert DateTime.diff(message.exp_at, message.enc_at) == ttl * 60
    end

    test "returns invalid changeset when invalid params" do
      ttl = 2
      invalid_params = %{"ttl" => ttl}

      raw = "Raw text"
      key = "key"

      {:error, changeset} = @module.insert_encrypted_message(raw, key, invalid_params)

      refute changeset.valid?
    end
  end

  describe "encrypt_message/4" do
    test "successfully inserts when params are valid" do
      valid_params = %{"short_description" => "short desc"}

      {:ok, message} = @module.insert_new_message(valid_params)

      ttl = 2
      valid_params = %{"ttl" => ttl}

      raw = "Raw text"
      key = "key"

      {:ok, message} = @module.encrypt_message(message, raw, key, valid_params)

      assert message.state == :encrypted
      assert message.txt != raw
      assert DateTime.diff(message.exp_at, message.enc_at) == ttl * 60
    end

    test "returns invalid changeset when invalid params" do
      message = %SecureStorage.Schema.EncryptedMessage{}
      ttl = 2
      valid_params = %{"ttl" => ttl}

      raw = "Raw text"
      key = "key"

      {:error, changeset} = @module.encrypt_message(message, raw, key, valid_params)

      refute changeset.valid?
    end
  end

  describe "stale_or_expired_messaages/0" do
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

    test "includes only messages with stale states", context do
      %{
        expired_message: expired_message,
        no_attempts_left_message: no_attempts_left_message,
        no_reads_left_message: no_reads_left_message,
        new_message: new_message
      } = context

      messages = @module.stale_or_expired_messages()

      assert expired_message in messages
      assert no_attempts_left_message in messages
      assert no_reads_left_message in messages

      refute new_message in messages
    end
  end
end
