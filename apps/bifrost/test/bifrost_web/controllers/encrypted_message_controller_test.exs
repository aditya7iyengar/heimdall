defmodule BifrostWeb.EncryptedMessageControllerTest do
  use BifrostWeb.ConnCase

  import Mox
  alias EncryptedMessagesMock, as: Mock
  alias SecureStorage.Schema.EncryptedMessage

  @valid_encrypted_message_params %{
    "raw" => "Raw",
    "key" => "key",
    "short_description" => "Some description",
    "encryption_algo" => "aes_gcm",
    "max_attempts" => 999,
    "ttl" => 5
  }

  describe "new/2" do
    test "renders the new.html template", %{auth_conn: conn} do
      conn = get(conn, Routes.encrypted_message_path(conn, :new))

      # TODO: Test more using floki
      assert html_response(conn, 200) =~ "Insert Secure Data"
    end
  end

  describe "create/2" do
    setup do
      stub(Mock, :insert_encrypted_message, fn
        "bad", _, _ ->
          {:error, %Ecto.Changeset{valid?: false, errors: []}}

        _, _, _ ->
          {
            :ok,
            %EncryptedMessage{
              state: :encrypted,
              short_description: "Description",
              encryption_algo: "plain",
              txt: "raw"
            }
          }
      end)

      :ok
    end

    test "adds encrypted_message to SecureStorage and redirects to root", %{auth_conn: conn} do
      conn =
        post(
          conn,
          Routes.encrypted_message_path(conn, :create),
          encrypted_message: @valid_encrypted_message_params
        )

      assert html_response(conn, 302) =~ "redirected"
      assert conn.private.plug_session["phoenix_flash"]["info"] =~ "Inserted"
    end

    test "adds encrypted_message to SecureStorage (with binary ttl)", %{auth_conn: conn} do
      params =
        @valid_encrypted_message_params
        |> Map.put("ttl", "5")
        |> Map.put("max_attempts", "2")

      conn =
        post(
          conn,
          Routes.encrypted_message_path(conn, :create),
          encrypted_message: params
        )

      assert html_response(conn, 302) =~ "redirected"
      assert conn.private.plug_session["phoenix_flash"]["info"] =~ "Inserted"
    end

    test "flashes error when insert is unsuccessful", %{auth_conn: conn} do
      params = %{@valid_encrypted_message_params | "raw" => "bad"}

      conn =
        post(
          conn,
          Routes.encrypted_message_path(conn, :create),
          encrypted_message: params
        )

      assert conn.status == 200
      assert conn.request_path == "/encrypted_messages"
    end
  end

  describe "delete/2" do
    test "deletes an EncryptedMessage from SecureStorage and redirects to root", %{
      auth_conn: conn
    } do
      stub(Mock, :delete_message, fn _ -> {:ok, nil} end)

      conn =
        delete(
          conn,
          Routes.encrypted_message_path(conn, :delete, "xyz")
        )

      assert html_response(conn, 302) =~ "redirected"
      assert conn.private.plug_session["phoenix_flash"]["info"] =~ "Deleted"
    end
  end
end
