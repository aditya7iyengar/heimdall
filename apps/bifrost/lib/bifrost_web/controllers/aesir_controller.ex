defmodule BifrostWeb.AesirController do
  use BifrostWeb, :controller

  def new(conn, _params), do: render(conn, "new.html", conn: conn)

  def create(conn, %{"aesir" => aesir_params}) do
    args = parse_aesir_args(aesir_params)

    case apply(Asguard, :insert, args) do
      {:ok, uuid} ->
        conn
        |> put_flash(:info, "Inserted aesir #{uuid}")
        |> redirect(to: "/")

      {:error, :could_not_insert} ->
        conn
        |> put_flash(:error, "Error in insertion")
        |> redirect(to: "/")
    end
  end

  defp parse_aesir_args(aesir_params) do
    encryption_algo =
      aesir_params
      |> Map.fetch!("encryption_algo")
      |> translate_to_asguardian_algo()

    [
      Map.fetch!(aesir_params, "raw"),
      Map.fetch!(aesir_params, "key"),
      Map.fetch!(aesir_params, "description"),
      encryption_algo
    ]
  end

  defp translate_to_asguardian_algo("aes"), do: :aes_gcm
  defp translate_to_asguardian_algo("plain"), do: :plaintext
end
