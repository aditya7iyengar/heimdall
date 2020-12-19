defmodule HeimdallQL.Schema.LoanTypesTest do
  use HeimdallQL.AbsintheCase

  import Mox

  alias EncryptedMessagesMock, as: Mock
  alias SecureStorage.Schema.EncryptedMessage

  describe "encrypted_messages" do
    setup do
      encrypted_message =
        %EncryptedMessage{state: :new, short_description: "desc"}
        |> EncryptedMessage.changeset(%{})
        |> Ecto.Changeset.apply_changes()

      stub(Mock, :list_messages, fn -> [encrypted_message] end)
      stub(Mock, :get_message, fn _ -> encrypted_message end)

      {:ok, encrypted_message: encrypted_message}
    end

    test "lists encrypted_messages", %{encrypted_message: encrypted_message} do
      query = """
      query {
        encrypted_messages {
          short_description
          txt
          encryption_algo
          id
        }
      }
      """

      {:ok, %{data: %{"encrypted_messages" => [result]}}} =
        run(
          query,
          HeimdallQL.Schema
        )

      expected_result = %{
        "short_description" => encrypted_message.short_description,
        "txt" => encrypted_message.txt,
        "encryption_algo" => to_string(encrypted_message.encryption_algo),
        "id" => encrypted_message.id
      }

      assert expected_result == result
    end

    test "gets encrypted_message", %{encrypted_message: encrypted_message} do
      query = """
      query {
        encrypted_message(id: "#{encrypted_message.id}") {
          short_description
          txt
          encryption_algo
          id
        }
      }
      """

      {:ok, %{data: %{"encrypted_message" => result}}} =
        run(
          query,
          HeimdallQL.Schema
        )

      expected_result = %{
        "short_description" => encrypted_message.short_description,
        "txt" => encrypted_message.txt,
        "encryption_algo" => to_string(encrypted_message.encryption_algo),
        "id" => encrypted_message.id
      }

      assert expected_result == result
    end

    test "creates encrypted_message" do
      raw = "raw"
      key = "key"
      short_description = "desc"

      stub(Mock, :insert_encrypted_message, fn _, _, _ ->
        {
          :ok,
          %EncryptedMessage{
            state: :encrypted,
            short_description: "desc",
            encryption_algo: "aes_gcm",
            txt: "xyzsada"
          }
        }
      end)

      mut = """
      mutation CreateEncryptedMessage {
        createEncryptedMessage(
          short_description: "#{short_description}",
          raw: "#{raw}",
          key: "#{key}",
      ) {
          short_description
          txt
          encryption_algo
        }
      }
      """

      {:ok, %{data: %{"createEncryptedMessage" => result}}} =
        run(
          mut,
          HeimdallQL.Schema
        )

      assert Map.fetch!(result, "short_description") == short_description
      refute Map.fetch!(result, "txt") == raw
      assert Map.fetch!(result, "encryption_algo") == "aes_gcm"
    end
  end
end
