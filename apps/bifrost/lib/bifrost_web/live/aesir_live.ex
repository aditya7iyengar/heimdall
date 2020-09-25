defmodule BifrostWeb.AesirLive do
  use BifrostWeb, :live_view

  @impl true
  def mount(%{"uuid" => uuid}, _session, socket) do
    result = Asguard.get_encrypted(uuid)

    {:ok, assign(socket, result: result)}
  end

  @impl true
  def handle_event("decrypt", %{"key" => key, "uuid" => uuid}, socket) do
    result = Asguard.get(uuid, key)

    case result do
      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Secure data not found. Maybe it expired...")
         |> assign(result: result)}

      {:error, :decryption_error} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error in decryption")
         |> assign(result: Asguard.get_encrypted(uuid))}

      _ ->
        {:noreply,
         socket
         |> put_flash(:info, "Message decrypted and ready to copy to clipboard")
         |> assign(result: result)}
    end
  end
end
