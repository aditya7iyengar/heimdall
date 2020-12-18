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
    params = clean_up_params(encrypted_message_params)

    [
      Map.fetch!(encrypted_message_params, "raw"),
      Map.fetch!(encrypted_message_params, "key"),
      params
    ]
  end

  defp clean_up_params(encrypted_message_params) do
    encryption_algo =
      encrypted_message_params
      |> Map.fetch!("encryption_algo")
      |> translate_to_asguardian_algo()

    ttl =
      encrypted_message_params
      |> Map.fetch!("ttl")
      |> ttl_from_params()

    max_attempts =
      case Map.get(encrypted_message_params, "max_attempts") do
        "infinite" -> nil
        "" -> nil
        str -> String.to_integer(str)
      end

    max_reads =
      case Map.get(encrypted_message_params, "max_reads") do
        "infinite" -> nil
        "" -> nil
        str -> String.to_integer(str)
      end

    encrypted_message_params
    |> Map.put("encryption_algo", encryption_algo)
    |> Map.put("ttl", ttl)
    |> Map.put("max_attempts", max_attempts)
    |> Map.put("max_reads", max_reads)
  end

  defp translate_to_asguardian_algo("aes"), do: :aes_gcm
  defp translate_to_asguardian_algo("plain"), do: :plain

  defp ttl_from_params(integer) when is_integer(integer), do: integer
  defp ttl_from_params(str) when is_binary(str), do: String.to_integer(str)
end
