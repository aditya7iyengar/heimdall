defmodule HeimdallQL do
  @moduledoc """
  QL context for Heimdall
  """

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case authorize(conn) do
      :ok ->
        Absinthe.Plug.put_options(conn, context: %{authorized: true})

      :error ->
        conn
        |> put_status(401)
        |> halt()
    end
  end

  defp authorize(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- token == "#{username()}:#{password()}" do
      :ok
    else
      _ -> :error
    end
  end

  defp username do
    Application.get_env(:heimdall_ql, :username)
  end

  defp password do
    Application.get_env(:heimdall_ql, :password)
  end
end
