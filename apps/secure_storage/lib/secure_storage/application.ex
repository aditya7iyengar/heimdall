defmodule SecureStorage.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      SecureStorage.Repo
    ]

    opts = [strategy: :one_for_one, name: SecureStorage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
