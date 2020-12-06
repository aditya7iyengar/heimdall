defmodule BifrostWeb.AesirController do
  use BifrostWeb, :controller

  def new(conn, _params), do: render(conn, "new.html", conn: conn)

  def create(conn, %{"aesir" => aesir_params}) do
    args = parse_aesir_args(aesir_params)

    {:ok, uuid} = apply(Asguard, :insert, args)

    conn
    |> put_flash(:info, "Inserted aesir #{uuid}")
    |> redirect(to: "/")
  end

  def delete(conn, %{"id" => uuid}) do
    case Asguard.delete(uuid) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Deleted aesir #{uuid}")
        |> redirect(to: "/")

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Cannot find aesir with id: #{uuid}")
        |> redirect(to: "/")
    end
  end

  # TODO: Move to someplace else
  defp parse_aesir_args(aesir_params) do
    encryption_algo =
      aesir_params
      |> Map.fetch!("encryption_algo")
      |> translate_to_asguardian_algo()

    ttl =
      aesir_params
      |> Map.fetch!("ttl")
      |> ttl_from_params()

    max_attempts =
      case Map.get(aesir_params, "max_attempts") do
        "infinite" -> :infinite
        "" -> :infinite
        str -> String.to_integer(str)
      end

    [
      Map.fetch!(aesir_params, "raw"),
      Map.fetch!(aesir_params, "key"),
      encryption_algo,
      %{
        description: Map.fetch!(aesir_params, "description"),
        max_attempts: max_attempts
      },
      ttl
    ]
  end

  defp translate_to_asguardian_algo("aes"), do: :aes_gcm
  defp translate_to_asguardian_algo("plain"), do: :plaintext

  defp ttl_from_params(integer) when is_integer(integer), do: integer
  defp ttl_from_params(str) when is_binary(str), do: String.to_integer(str)
end
