defmodule BifrostWeb.PageLive do
  use BifrostWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    case String.length(query) > 3 do
      true ->
        {:noreply, assign(socket, results: search(query), query: query)}

      false ->
        {:noreply, assign(socket, query: query, results: [])}
    end
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      [] ->
        {:noreply,
         socket
         |> put_flash(:error, "No encrypted_messages found matching \"#{query}\"")
         |> assign(results: [], query: query)}

      encrypted_messages ->
        num = Enum.count(encrypted_messages)

        {:noreply,
         socket
         |> put_flash(:info, "Found #{num} encrypted_messages found matching \"#{query}\"")
         |> assign(results: encrypted_messages, query: query)}
    end
  end

  defp search(query) do
    SecureStorage.search_messages(query)
  end
end
