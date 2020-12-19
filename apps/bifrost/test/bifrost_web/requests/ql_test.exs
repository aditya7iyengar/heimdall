defmodule BifrostWeb.QLTest do
  use BifrostWeb.APIConnCase

  import Mox

  alias EncryptedMessagesMock, as: Mock
  alias SecureStorage.Schema.EncryptedMessage

  @graphql_path "/api/graphql"

  describe "ql list" do
    setup ctx do
      encrypted_message =
        %EncryptedMessage{state: :new, short_description: "desc"}
        |> EncryptedMessage.changeset(%{})
        |> Ecto.Changeset.apply_changes()

      stub(Mock, :list_messages, fn -> [encrypted_message] end)

      {:ok, Map.put(ctx, :encrypted_message, encrypted_message)}
    end

    test "lists all encrypted_messages when authorized", %{
      auth_conn: conn,
      encrypted_message: encrypted_message
    } do
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

      conn = post(conn, @graphql_path, query)

      assert conn.status == 200

      encrypted_messages =
        conn.resp_body
        |> Jason.decode!()
        |> Map.get("data")
        |> Map.get("encrypted_messages")

      assert Enum.count(encrypted_messages) == 1

      [encrypted_message_response] = encrypted_messages

      assert encrypted_message_response["short_description"] ==
               encrypted_message.short_description

      assert encrypted_message_response["id"] == encrypted_message.id
      assert encrypted_message_response["txt"] == encrypted_message.txt

      assert encrypted_message_response["encryption_algo"] ==
               to_string(encrypted_message.encryption_algo)
    end

    test "401 when unauthorized", %{unauth_conn: conn} do
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

      conn = post(conn, @graphql_path, query)

      assert conn.status == 401
    end
  end
end
