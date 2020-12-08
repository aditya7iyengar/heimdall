defmodule HeimdallQL.ResolverTest do
  use ExUnit.Case

  alias SecureStorage.Repo
  alias SecureStorage.Schema.EncryptedMessage

  @module HeimdallQL.Resolver

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "list_encrypted_messages/3" do
    setup do
      encrypted_message =
        %EncryptedMessage{state: :new, short_description: "desc"}
        |> EncryptedMessage.changeset(%{})
        |> Repo.insert!()

      {:ok, encrypted_message: encrypted_message}
    end

    test "lists encrypted_messages", %{encrypted_message: encrypted_message} do
      {status, list} = @module.list_encrypted_messages(nil, nil, nil)

      assert status == :ok
      assert list == [encrypted_message]
    end
  end

  describe "get_encrypted_message/3" do
    setup do
      encrypted_message =
        %EncryptedMessage{state: :new, short_description: "desc"}
        |> EncryptedMessage.changeset(%{})
        |> Repo.insert!()

      {:ok, encrypted_message: encrypted_message}
    end

    test "gets encrypted_message", %{encrypted_message: encrypted_message} do
      {status, fetched} = @module.get_encrypted_message(nil, %{id: encrypted_message.id}, nil)

      assert status == :ok
      assert fetched == encrypted_message
    end
  end

  describe "create_encrypted_messages/3" do
    test "creates encrypted_message" do
      params = %{
        raw: "raw",
        key: :key,
        short_description: "Description",
        encryption_algo: "plain"
      }

      {status, created} = @module.create_encrypted_message(nil, params, nil)

      assert status == :ok
      assert created.txt == params.raw
      assert created.short_description == params.short_description
      assert to_string(created.encryption_algo) == params.encryption_algo
    end
  end
end
