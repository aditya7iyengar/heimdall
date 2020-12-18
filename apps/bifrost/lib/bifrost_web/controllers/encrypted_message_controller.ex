defmodule BifrostWeb.EncryptedMessageController do
  use BifrostWeb, :controller

  def new(conn, _params), do: render(conn, "new.html", conn: conn)

  def create(conn, %{"encrypted_message" => encrypted_message_params}) do
    args = parse_encrypted_message_args(encrypted_message_params)

    case apply(SecureStorage, :insert_encrypted_message, args) do
      {:ok, encrypted_message} ->
        conn
        |> put_flash(:info, "Inserted encrypted_message #{encrypted_message.id}")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case SecureStorage.delete_message(id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Deleted encrypted_message #{id}")
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Cannot find encrypted_message with id: #{id}")
        |> redirect(to: "/")
    end
  end

  defp parse_encrypted_message_args(encrypted_message_params) do
    params = Map.drop(encrypted_message_params, ["raw", "key"])

    [
      Map.fetch!(encrypted_message_params, "raw"),
      Map.fetch!(encrypted_message_params, "key"),
      params
    ]
  end
end
