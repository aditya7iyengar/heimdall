defmodule SecureStorage.DataCase do
  @moduledoc """
  Data Test Helpers
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias SecureStorage.Repo
    end
  end

  setup tags do
    :ok = Sandbox.checkout(SecureStorage.Repo)

    unless tags[:async] do
      Sandbox.mode(SecureStorage.Repo, {:shared, self()})
    end

    :ok
  end
end
