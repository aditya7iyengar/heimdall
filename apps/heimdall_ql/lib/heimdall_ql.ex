defmodule HeimdallQL do
  @moduledoc """
  QL context for Heimdall
  """

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case authenticate(conn) do
      :ok ->
        Absinthe.Plug.put_options(conn, context: %{authenticated: true})

      :error ->
        conn
        |> put_status(401)
        |> halt()
    end
  end

  # TODO: Add authentication
  defp authenticate(_conn), do: :ok
end
