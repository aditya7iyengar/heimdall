defmodule BifrostWeb.QLTest do
  use BifrostWeb.APIConnCase

  @graphql_path "/api/graphql"

  describe "ql list" do
    setup ctx do
      SecureStorage.start_link([])

      {:ok, uuid} =
        SecureStorage.insert(
          "raw",
          :key,
          :plaintext,
          %{description: "Description"}
        )

      {:ok, encrypted_message} = SecureStorage.get_encrypted(uuid)

      on_exit(fn ->
        SecureStorage.delete(uuid)
      end)

      {:ok, Map.put(ctx, :encrypted_message, encrypted_message)}
    end

    test "lists all encrypted_messages when authorized", %{
      auth_conn: conn,
      encrypted_message: encrypted_message
    } do
      query = """
      query {
        encrypted_messages {
          description
          encrypted
          encryption_algo
          uuid
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

      assert encrypted_message_response["description"] == encrypted_message.description
      assert encrypted_message_response["uuid"] == encrypted_message.uuid
      assert encrypted_message_response["encrypted"] == encrypted_message.encrypted

      assert encrypted_message_response["encryption_algo"] ==
               to_string(encrypted_message.encryption_algo)
    end

    test "401 when unauthorized", %{unauth_conn: conn} do
      query = """
      query {
        encrypted_messages {
          description
          encrypted
          encryption_algo
          uuid
        }
      }
      """

      conn = post(conn, @graphql_path, query)

      assert conn.status == 401
    end
  end
end
