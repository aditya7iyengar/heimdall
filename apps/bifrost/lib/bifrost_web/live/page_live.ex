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
         |> put_flash(:error, "No aesirs found matching \"#{query}\"")
         |> assign(results: [], query: query)}

      aesirs ->
        num = Enum.count(aesirs)

        {:noreply,
         socket
         |> put_flash(:info, "Found #{num} aesirs found matching \"#{query}\"")
         |> assign(results: aesirs, query: query)}
    end
  end

  defp search(query) do
    if not BifrostWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    Asguard.search(query)
  end
end
