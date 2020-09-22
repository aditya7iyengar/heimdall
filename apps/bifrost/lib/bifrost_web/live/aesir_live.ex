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
      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error in decryption")
         |> assign(result: result)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:info, "Message decrypted and ready to copy to clipboard")
         |> assign(result: result)}
    end
  end
end
