defmodule BifrostWeb.EncryptedMessageLive do
  use BifrostWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    result = SecureStorage.get_message(id)

    {:ok, assign(socket, result: result, show: false)}
  end

  @impl true
  def handle_event("decrypt", %{"key" => key, "id" => id}, socket) do
    message = SecureStorage.get_message(id)
    result = SecureStorage.decrypt_message(message, key)

    case message && result do
      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(:error, "Secure data not found. Maybe it expired...")
         |> assign(show: false)}

      {:error, :decryption_error} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error in decryption")
         |> assign(message: message, show: false)}

      {:error, :no_attempts_remaining} ->
        {:noreply,
         socket
         |> put_flash(:error, "No Attempts remaining")
         |> assign(message: message, show: false)}

      _ ->
        {:noreply,
         socket
         |> put_flash(:info, "Message decrypted and ready to copy to clipboard")
         |> assign(message: message, result: result, show: false)}
    end
  end

  @impl true
  def handle_event("show", _, socket) do
    {:noreply,
     socket
     |> assign(show: true)}
  end

  @impl true
  def handle_event("hide", _, socket) do
    {:noreply,
     socket
     |> assign(show: false)}
  end
end
