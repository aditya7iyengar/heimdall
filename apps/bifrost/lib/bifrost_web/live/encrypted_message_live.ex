defmodule BifrostWeb.EncryptedMessageLive do
  use BifrostWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    message = SecureStorage.get_message(id)

    {:ok, assign(socket, message: message, result: nil, show: false)}
  end

  @impl true
  def handle_event("decrypt", %{"key" => key, "id" => id}, socket) do
    message = SecureStorage.get_message(id)

    case message && SecureStorage.decrypt_message(message, key) do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "Secure data not found. Maybe it expired...")
         |> assign(message: nil, result: nil, show: false)}

      {:error, :decryption_error} ->
        {:noreply,
         socket
         |> put_flash(:error, "Error in decryption")
         |> assign(message: message, result: nil, show: false)}

      {:error, :no_attempts_remaining} ->
        {:noreply,
         socket
         |> put_flash(:error, "No Attempts remaining")
         |> assign(message: message, result: nil, show: false)}

      {:error, :no_reads_remaining} ->
        {:noreply,
         socket
         |> put_flash(:error, "No Reads remaining")
         |> assign(message: message, result: nil, show: false)}

      {:ok, decrypted} when is_binary(decrypted) ->
        {:noreply,
         socket
         |> put_flash(:info, "Message decrypted and ready to copy to clipboard")
         |> assign(message: message, result: decrypted, show: false)}
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
