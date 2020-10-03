defmodule BifrostWeb.QLTest do
  use BifrostWeb.APIConnCase

  @graphql_path "/api/graphql"

  describe "ql list" do
    setup ctx do
      Asguard.start_link([])

      {:ok, uuid} = Asguard.insert("raw", :key, "Description", :plaintext)

      {:ok, aesir} = Asguard.get_encrypted(uuid)

      on_exit(fn ->
        Asguard.delete(uuid)
      end)

      {:ok, Map.put(ctx, :aesir, aesir)}
    end

    test "lists all aesirs when authorized", %{auth_conn: conn, aesir: aesir} do
      query = """
      query {
        aesirs {
          description
          encrypted
          encryption_algo
          uuid
        }
      }
      """

      conn = post(conn, @graphql_path, query)

      assert conn.status == 200

      aesirs =
        conn.resp_body
        |> Jason.decode!()
        |> Map.get("data")
        |> Map.get("aesirs")

      assert Enum.count(aesirs) == 1

      [aesir_response] = aesirs

      assert aesir_response["description"] == aesir.description
      assert aesir_response["uuid"] == aesir.uuid
      assert aesir_response["encrypted"] == aesir.encrypted

      assert aesir_response["encryption_algo"] ==
               to_string(aesir.encryption_algo)
    end

    test "401 when unauthorized", %{unauth_conn: conn} do
      query = """
      query {
        aesirs {
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
