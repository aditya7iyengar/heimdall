defmodule SecureStorage.EncryptedMessagesTest do
  use SecureStorage.DataCase

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
end
